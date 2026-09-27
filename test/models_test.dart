import 'package:campus_swap/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Listing survives a JSON round trip', () {
    final listing = Listing(
      id: 'listing-1',
      sellerId: 'seller-1',
      sellerName: 'Ada Lovelace',
      title: 'Calculus Textbook',
      description: 'Gently used, no highlighting.',
      price: 45,
      category: ListingCategory.textbooks,
      condition: ListingCondition.likeNew,
      type: ListingType.sale,
      campus: 'Main Campus',
      courseCode: 'MATH 101',
      isbn: '978-0-13-468599-1',
      imageUrls: const <String>['https://example.com/a.jpg'],
      createdAt: DateTime(2026, 1, 1, 9),
      updatedAt: DateTime(2026, 1, 2, 10),
    );

    expect(Listing.fromJson(listing.toJson()), listing);
  });

  test('Listing decodes Firestore timestamps and ISO strings', () {
    final listing = Listing.fromJson(<String, dynamic>{
      'id': 'listing-1',
      'sellerId': 'seller-1',
      'sellerName': 'Ada Lovelace',
      'title': 'Calculus Textbook',
      'description': 'Gently used, no highlighting.',
      'price': 45,
      'category': 'textbooks',
      'condition': 'likeNew',
      'type': 'sale',
      'campus': 'Main Campus',
      'createdAt': Timestamp.fromDate(DateTime(2026, 2, 3)),
      'updatedAt': '2026-02-04T10:00:00.000',
    });

    expect(listing.createdAt, DateTime(2026, 2, 3));
    expect(listing.updatedAt, DateTime(2026, 2, 4, 10));
    expect(listing.imageUrls, isEmpty);
    expect(listing.viewCount, 0);
    expect(listing.status, ListingStatus.active);
  });

  test('UserProfile defaults its FCM tokens, rating and role', () {
    final profile = UserProfile.fromJson(<String, dynamic>{
      'id': 'user-1',
      'email': 'ada@campus.edu',
      'displayName': 'Ada Lovelace',
      'university': 'Campus State',
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    });

    expect(profile.fcmTokens, isEmpty);
    expect(profile.photoUrl, isNull);
    expect(profile.rating, 0);
    expect(profile.ratingCount, 0);
    expect(profile.role, 'user');
  });

  test('Listing defaults author, favoriteCount and sellerPhoto', () {
    final listing = Listing.fromJson(<String, dynamic>{
      'id': 'listing-1',
      'sellerId': 'seller-1',
      'sellerName': 'Ada Lovelace',
      'title': 'Calculus Textbook',
      'description': 'Gently used, no highlighting.',
      'price': 45,
      'category': 'textbooks',
      'condition': 'good',
      'type': 'sale',
      'campus': 'Main Campus',
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
      'updatedAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    });

    expect(listing.author, isNull);
    expect(listing.sellerPhoto, isNull);
    expect(listing.favoriteCount, 0);
  });

  test('AppNotification round trips and defaults to unread', () {
    final notification = AppNotification(
      id: 'notif-1',
      title: 'New message',
      body: 'Ada: is this still available?',
      type: NotificationType.message,
      relatedId: 'conversation-1',
      createdAt: DateTime(2026, 1, 4, 8),
    );

    final decoded = AppNotification.fromJson(notification.toJson());
    expect(decoded, notification);
    expect(decoded.read, isFalse);
    expect(decoded.type, NotificationType.message);
  });

  test('Conversation carries per-user unread counts', () {
    final conversation = Conversation.fromJson(<String, dynamic>{
      'id': 'conversation-1',
      'listingId': 'listing-1',
      'listingTitle': 'Calculus Textbook',
      'buyerId': 'user-2',
      'buyerName': 'Grace Hopper',
      'sellerId': 'user-1',
      'sellerName': 'Ada Lovelace',
      'participantIds': const <String>['user-1', 'user-2'],
      'lastMessage': 'Hi',
      'lastMessageAt': Timestamp.fromDate(DateTime(2026, 1, 3)),
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 3)),
      'unreadCounts': const <String, dynamic>{'user-1': 2},
    });

    expect(conversation.unreadCounts['user-1'], 2);
    expect(conversation.unreadCounts['user-2'], isNull);
  });

  test('SwapProposal defaults to pending', () {
    final proposal = SwapProposal.fromJson(<String, dynamic>{
      'id': 'swap-1',
      'listingId': 'listing-1',
      'listingTitle': 'Calculus Textbook',
      'offererId': 'user-2',
      'ownerId': 'user-1',
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
      'updatedAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    });

    expect(proposal.status, SwapStatus.pending);
    expect(proposal.message, isNull);
  });

  test('Report defaults to an open status', () {
    final report = Report.fromJson(<String, dynamic>{
      'id': 'report-1',
      'reporterId': 'user-2',
      'listingId': 'listing-1',
      'reason': 'Spam or scam',
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    });

    expect(report.status, 'open');
    expect(report.details, isNull);
  });

  test('Message and Conversation round trip through JSON', () {
    final conversation = Conversation(
      id: 'conversation-1',
      listingId: 'listing-1',
      listingTitle: 'Calculus Textbook',
      buyerId: 'user-2',
      buyerName: 'Grace Hopper',
      sellerId: 'user-1',
      sellerName: 'Ada Lovelace',
      participantIds: const <String>['user-1', 'user-2'],
      lastMessage: 'Is this still available?',
      lastMessageAt: DateTime(2026, 1, 3, 12),
      createdAt: DateTime(2026, 1, 3, 12),
    );
    final message = Message(
      id: 'message-1',
      senderId: 'user-2',
      text: 'Is this still available?',
      sentAt: DateTime(2026, 1, 3, 12),
    );

    expect(Conversation.fromJson(conversation.toJson()), conversation);
    expect(Message.fromJson(message.toJson()), message);
    expect(Message.fromJson(message.toJson()).readBy, isEmpty);
  });
}
