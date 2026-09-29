import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

/// One page of listings plus the cursor needed to fetch the next page.
class ListingPage {
  const ListingPage({
    required this.listings,
    required this.cursor,
    required this.hasMore,
  });

  final List<Listing> listings;
  final DocumentSnapshot<Map<String, dynamic>>? cursor;
  final bool hasMore;
}

class FirestoreRepository {
  FirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _listings =>
      _firestore.collection('listings');

  Stream<List<Listing>> watchListings({String? ownerId}) {
    Query<Map<String, dynamic>> query = _listings
        .where(
          ownerId == null ? 'status' : 'sellerId',
          isEqualTo: ownerId ?? ListingStatus.active.name,
        )
        .orderBy('createdAt', descending: true)
        .limit(50);
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Listing.fromJson({...doc.data(), 'id': doc.id}))
          .toList(),
    );
  }

  /// Fetches one page of active listings, newest first. Returns the fetched
  /// listings, the cursor to pass as [after] for the next page, and whether
  /// more pages are likely to exist.
  Future<ListingPage> pageListings({
    DocumentSnapshot<Map<String, dynamic>>? after,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query = _listings
        .where('status', isEqualTo: ListingStatus.active.name)
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (after != null) query = query.startAfterDocument(after);
    final snapshot = await query.get();
    return ListingPage(
      listings: snapshot.docs
          .map((doc) => Listing.fromJson({...doc.data(), 'id': doc.id}))
          .toList(),
      cursor: snapshot.docs.isEmpty ? after : snapshot.docs.last,
      hasMore: snapshot.docs.length == limit,
    );
  }

  Future<Listing?> getListing(String id) async {
    final snapshot = await _listings.doc(id).get();
    final data = snapshot.data();
    return data == null ? null : Listing.fromJson({...data, 'id': snapshot.id});
  }

  Future<String> createListing(Listing listing) async {
    await _listings.doc(listing.id).set({
      ...listing.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return listing.id;
  }

  Future<void> updateListing(Listing listing) {
    // Never resend createdAt: it was written with a server timestamp and the
    // security rules require it to stay byte-for-byte unchanged, which a
    // client-clock round-trip can't guarantee.
    final data = listing.toJson()..remove('createdAt');
    return _listings.doc(listing.id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteListing(String id) => _listings.doc(id).delete();

  Future<void> updateListingStatus(String id, ListingStatus status) =>
      _listings.doc(id).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  /// Reads one of a listing's numeric counters.
  ///
  /// The security rules only let a counter move by exactly one, and they check
  /// that by comparing the incoming value with the stored one. A numeric
  /// [FieldValue.increment] is not visible to the rules engine on production
  /// Firestore — the emulator resolves it, production does not — so an
  /// increment on someone else's listing is rejected with PERMISSION_DENIED.
  /// The arithmetic therefore happens here and the result is sent as a literal
  /// value, which the rules can compare.
  int _counter(Map<String, dynamic>? data, String field) =>
      (data?[field] as num?)?.toInt() ?? 0;

  /// Registers a single view. Runs in a transaction so two students opening the
  /// listing at once can't both read the same value and have one write denied.
  Future<void> incrementViewCount(String id) async {
    final ref = _listings.doc(id);
    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      final data = snapshot.data();
      if (data == null) return;
      tx.update(ref, {'viewCount': _counter(data, 'viewCount') + 1});
    });
  }

  Stream<List<Conversation>> watchConversations(String uid) => _firestore
      .collection('conversations')
      .where('participantIds', arrayContains: uid)
      .orderBy('lastMessageAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Conversation.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),
      );

  Future<String> createOrGetConversation({
    required Listing listing,
    required String buyerId,
    required String buyerName,
  }) async {
    final existing = await _firestore
        .collection('conversations')
        // The read rule requires request.auth.uid to be in participantIds, and
        // Firestore rejects any query it can't prove satisfies that — so the
        // query must constrain participantIds, not just buyerId, or it fails
        // with permission-denied. The caller only reaches here as the buyer (a
        // seller can't message their own listing), so the one conversation for
        // this listing that lists this user is their buyer-side conversation.
        .where('participantIds', arrayContains: buyerId)
        .where('listingId', isEqualTo: listing.id)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return existing.docs.first.id;
    final id = _uuid.v4();
    final now = DateTime.now();
    final conversation = Conversation(
      id: id,
      listingId: listing.id,
      listingTitle: listing.title,
      buyerId: buyerId,
      buyerName: buyerName,
      sellerId: listing.sellerId,
      sellerName: listing.sellerName,
      participantIds: [buyerId, listing.sellerId],
      lastMessage: '',
      lastMessageAt: now,
      createdAt: now,
    );
    await _firestore
        .collection('conversations')
        .doc(id)
        .set(conversation.toJson());
    return id;
  }

  Stream<List<Message>> watchMessages(String conversationId) => _firestore
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .orderBy('sentAt')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),
      );

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
    required String recipientId,
    String? imageUrl,
  }) async {
    final message = Message(
      id: _uuid.v4(),
      senderId: senderId,
      text: text.trim(),
      imageUrl: imageUrl,
      sentAt: DateTime.now(),
      readBy: [senderId],
    );
    final preview = imageUrl != null && message.text.isEmpty
        ? '📷 Photo'
        : message.text;
    final conversationRef = _firestore
        .collection('conversations')
        .doc(conversationId);
    final batch = _firestore.batch();
    batch.set(conversationRef.collection('messages').doc(message.id), {
      ...message.toJson(),
      'sentAt': FieldValue.serverTimestamp(),
    });
    batch.update(conversationRef, {
      'lastMessage': preview,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadBy': FieldValue.arrayUnion([recipientId]),
      'unreadCounts.$recipientId': FieldValue.increment(1),
    });
    await batch.commit();
    await createNotification(
      uid: recipientId,
      title: senderName.isEmpty ? 'New message' : senderName,
      body: preview,
      type: NotificationType.message,
      relatedId: conversationId,
    );
  }

  Future<void> markConversationRead(String conversationId, String uid) =>
      _firestore.collection('conversations').doc(conversationId).update({
        'unreadBy': FieldValue.arrayRemove([uid]),
        'unreadCounts.$uid': 0,
      });

  Stream<List<SwapProposal>> watchSwaps(String uid) => _firestore
      .collection('swaps')
      .where('participantIds', arrayContains: uid)
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => SwapProposal.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),
      );

  Future<void> createSwapProposal(SwapProposal proposal) async {
    await _firestore.collection('swaps').doc(proposal.id).set({
      ...proposal.toJson(),
      'participantIds': [proposal.offererId, proposal.ownerId],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await createNotification(
      uid: proposal.ownerId,
      title: 'New swap proposal',
      body: 'Someone wants to swap for "${proposal.listingTitle}".',
      type: NotificationType.swapRequest,
      relatedId: proposal.id,
    );
  }

  /// Owner accepts or declines a proposal. On accept the owner's listing is
  /// flipped to `swapped` in the same transaction so two proposals can't both
  /// win, and the offerer is notified either way.
  Future<void> respondToSwap(SwapProposal swap, SwapStatus status) async {
    final swapRef = _firestore.collection('swaps').doc(swap.id);
    await _firestore.runTransaction((tx) async {
      final current = await tx.get(swapRef);
      if ((current.data()?['status'] as String?) != SwapStatus.pending.name) {
        throw StateError('This proposal has already been answered.');
      }
      tx.update(swapRef, {
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (status == SwapStatus.accepted) {
        tx.update(_listings.doc(swap.listingId), {
          'status': ListingStatus.swapped.name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
    await createNotification(
      uid: swap.offererId,
      title: status == SwapStatus.accepted ? 'Swap accepted' : 'Swap declined',
      body: '"${swap.listingTitle}"',
      type: status == SwapStatus.accepted
          ? NotificationType.swapAccepted
          : NotificationType.swapDeclined,
      relatedId: swap.id,
    );
  }

  Future<void> cancelSwap(String id) =>
      _firestore.collection('swaps').doc(id).update({
        'status': SwapStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> createReport(Report report) => _firestore
      .collection('reports')
      .doc(report.id)
      .set({...report.toJson(), 'createdAt': FieldValue.serverTimestamp()});

  Stream<List<Listing>> watchFavorites(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('favorites')
      .orderBy('savedAt', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final listings = await Future.wait(
          snapshot.docs.map((doc) => getListing(doc.id)),
        );
        return listings.whereType<Listing>().toList();
      });

  Stream<bool> watchFavorite(String uid, String listingId) => _firestore
      .collection('users')
      .doc(uid)
      .collection('favorites')
      .doc(listingId)
      .snapshots()
      .map((snapshot) => snapshot.exists);

  Future<void> setFavorite(String uid, String listingId, bool value) async {
    final favoriteRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(listingId);
    final listingRef = _listings.doc(listingId);
    await _firestore.runTransaction((tx) async {
      final favorite = await tx.get(favoriteRef);
      // Only move the counter when the state actually changes, so repeated
      // taps can't drift the count away from reality.
      if (value && !favorite.exists) {
        final listing = await tx.get(listingRef);
        tx.set(favoriteRef, {'savedAt': FieldValue.serverTimestamp()});
        tx.update(listingRef, {
          'favoriteCount': _counter(listing.data(), 'favoriteCount') + 1,
        });
      } else if (!value && favorite.exists) {
        final listing = await tx.get(listingRef);
        tx.delete(favoriteRef);
        tx.update(listingRef, {
          'favoriteCount': _counter(listing.data(), 'favoriteCount') - 1,
        });
      }
    });
  }

  // --- Notifications -------------------------------------------------------

  CollectionReference<Map<String, dynamic>> _notifications(String uid) =>
      _firestore.collection('notifications').doc(uid).collection('items');

  Stream<List<AppNotification>> watchNotifications(String uid) =>
      _notifications(uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) =>
                      AppNotification.fromJson({...doc.data(), 'id': doc.id}),
                )
                .toList(),
          );

  Future<void> createNotification({
    required String uid,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedId,
  }) async {
    final id = _uuid.v4();
    await _notifications(uid).doc(id).set({
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'relatedId': relatedId,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markNotificationRead(String uid, String id) =>
      _notifications(uid).doc(id).update({'read': true});

  Future<void> markAllNotificationsRead(String uid) async {
    final unread = await _notifications(uid)
        .where('read', isEqualTo: false)
        .get();
    final batch = _firestore.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }
}
