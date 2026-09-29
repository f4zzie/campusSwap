import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'data/auth_repository.dart';
import 'data/firestore_repository.dart';
import 'data/storage_repository.dart';
import 'models/models.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
  ),
);
final firestoreRepositoryProvider = Provider<FirestoreRepository>(
  (ref) => FirestoreRepository(ref.watch(firestoreProvider)),
);
final storageRepositoryProvider = Provider<StorageRepository>(
  (ref) => StorageRepository(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final profileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user == null
      ? const Stream.empty()
      : ref.watch(authRepositoryProvider).watchProfile(user.uid);
});

/// Cursor-paginated browse feed. Loads active listings a page at a time via
/// [FirestoreRepository.pageListings] and appends on [loadMore].
class ListingFeedState {
  const ListingFeedState({
    this.items = const <Listing>[],
    this.cursor,
    this.status = const AsyncLoading<void>(),
    this.loadingMore = false,
    this.hasMore = true,
  });

  final List<Listing> items;
  final DocumentSnapshot<Map<String, dynamic>>? cursor;
  final AsyncValue<void> status;
  final bool loadingMore;
  final bool hasMore;
}

class ListingFeedNotifier extends Notifier<ListingFeedState> {
  @override
  ListingFeedState build() {
    _fetchFirst();
    return const ListingFeedState();
  }

  FirestoreRepository get _repo => ref.read(firestoreRepositoryProvider);

  Future<void> _fetchFirst() async {
    state = const ListingFeedState();
    try {
      final page = await _repo.pageListings();
      state = ListingFeedState(
        items: page.listings,
        cursor: page.cursor,
        hasMore: page.hasMore,
        status: const AsyncData<void>(null),
      );
    } catch (error, stack) {
      state = ListingFeedState(status: AsyncError<void>(error, stack));
    }
  }

  Future<void> refresh() => _fetchFirst();

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.status.isLoading) return;
    state = ListingFeedState(
      items: state.items,
      cursor: state.cursor,
      hasMore: state.hasMore,
      status: state.status,
      loadingMore: true,
    );
    try {
      final page = await _repo.pageListings(after: state.cursor);
      state = ListingFeedState(
        items: [...state.items, ...page.listings],
        cursor: page.cursor,
        hasMore: page.hasMore,
        status: const AsyncData<void>(null),
      );
    } catch (_) {
      state = ListingFeedState(
        items: state.items,
        cursor: state.cursor,
        hasMore: state.hasMore,
        status: state.status,
      );
    }
  }
}

final listingFeedProvider =
    NotifierProvider<ListingFeedNotifier, ListingFeedState>(
      ListingFeedNotifier.new,
    );

final myListingsProvider = StreamProvider<List<Listing>>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  return uid == null
      ? const Stream.empty()
      : ref.watch(firestoreRepositoryProvider).watchListings(ownerId: uid);
});

final favoritesProvider = StreamProvider<List<Listing>>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  return uid == null
      ? const Stream.empty()
      : ref.watch(firestoreRepositoryProvider).watchFavorites(uid);
});

final favoriteProvider = StreamProvider.family<bool, String>((ref, listingId) {
  final uid = ref.watch(currentUserProvider)?.uid;
  return uid == null
      ? const Stream.empty()
      : ref.watch(firestoreRepositoryProvider).watchFavorite(uid, listingId);
});

final listingProvider = FutureProvider.family<Listing?, String>((ref, id) {
  return ref.watch(firestoreRepositoryProvider).getListing(id);
});

final conversationsProvider = StreamProvider<List<Conversation>>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  return uid == null
      ? const Stream.empty()
      : ref.watch(firestoreRepositoryProvider).watchConversations(uid);
});

final messagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  id,
) {
  return ref.watch(firestoreRepositoryProvider).watchMessages(id);
});

final swapsProvider = StreamProvider<List<SwapProposal>>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  return uid == null
      ? const Stream.empty()
      : ref.watch(firestoreRepositoryProvider).watchSwaps(uid);
});

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  return uid == null
      ? const Stream.empty()
      : ref.watch(firestoreRepositoryProvider).watchNotifications(uid);
});

final unreadNotificationsProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider).value ?? const [];
  return items.where((item) => !item.read).length;
});

final themeModeProvider = StateProvider<bool>((ref) => false);
