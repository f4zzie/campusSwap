import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  ConsumerState<ListingDetailScreen> createState() =>
      _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  final _uuid = const Uuid();
  bool _actionBusy = false;
  bool _viewCounted = false;

  Future<void> _messageSeller(Listing listing) async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    final profile = ref.read(profileProvider).value;
    if (user == null || profile == null || user.uid == listing.sellerId) return;
    setState(() => _actionBusy = true);
    try {
      final id = await ref
          .read(firestoreRepositoryProvider)
          .createOrGetConversation(
            listing: listing,
            buyerId: user.uid,
            buyerName: profile.displayName,
          );
      if (mounted) context.push('/home/chat/$id');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    } finally {
      if (mounted) setState(() => _actionBusy = false);
    }
  }

  Future<void> _proposeSwap(Listing listing) async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null || user.uid == listing.sellerId) return;
    // Only the offerer's own active listings can be put on the table.
    final myListings = (ref.read(myListingsProvider).value ?? const <Listing>[])
        .where(
          (item) =>
              item.id != listing.id && item.status == ListingStatus.active,
        )
        .toList();
    final messageController = TextEditingController();
    Listing? offered;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Propose a swap',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text('Offer one of your listings for "${listing.title}".'),
              const SizedBox(height: 16),
              if (myListings.isEmpty)
                const Text(
                  'You have no active listings to offer yet — you can still '
                  'send a message below.',
                )
              else
                DropdownButtonFormField<Listing?>(
                  initialValue: offered,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Item you are offering',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No item — just ask'),
                    ),
                    ...myListings.map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => offered = value),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Message (optional)',
                  hintText: 'Add a note for the seller',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Send proposal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) {
      messageController.dispose();
      return;
    }
    try {
      final now = DateTime.now();
      await ref
          .read(firestoreRepositoryProvider)
          .createSwapProposal(
            SwapProposal(
              id: _uuid.v4(),
              listingId: listing.id,
              listingTitle: listing.title,
              offererId: user.uid,
              ownerId: listing.sellerId,
              offeredListingId: offered?.id,
              offeredListingTitle: offered?.title,
              message: messageController.text.trim().isEmpty
                  ? null
                  : messageController.text.trim(),
              createdAt: now,
              updatedAt: now,
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Swap proposal sent.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    } finally {
      messageController.dispose();
    }
  }

  Future<void> _report(Listing listing) async {
    const reasons = [
      'Inappropriate content',
      'Scam or suspicious listing',
      'Wrong information',
      'Prohibited item',
      'Spam',
      'Other',
    ];
    final detailsController = TextEditingController();
    var reason = reasons.first;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report listing',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: reason,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Reason'),
                items: reasons
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) => setSheetState(() => reason = value!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                maxLines: 3,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Details (optional)',
                  hintText: 'Tell us what is wrong with this listing.',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Submit report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) {
      detailsController.dispose();
      return;
    }
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) {
      detailsController.dispose();
      return;
    }
    try {
      await ref
          .read(firestoreRepositoryProvider)
          .createReport(
            Report(
              id: _uuid.v4(),
              reporterId: user.uid,
              listingId: listing.id,
              reason: reason,
              details: detailsController.text.trim().isEmpty
                  ? null
                  : detailsController.text.trim(),
              createdAt: DateTime.now(),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanks. We will review this listing.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    } finally {
      detailsController.dispose();
    }
  }

  Future<void> _ownerAction(Listing listing) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit listing'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Mark as sold'),
              onTap: () => Navigator.pop(context, 'sold'),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horizontal_circle_outlined),
              title: const Text('Mark as swapped'),
              onTap: () => Navigator.pop(context, 'swapped'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_rounded),
              title: const Text('Mark as pending'),
              onTap: () => Navigator.pop(context, 'pending'),
            ),
            if (listing.status != ListingStatus.active)
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: const Text('Mark as available'),
                onTap: () => Navigator.pop(context, 'available'),
              ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete listing',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    if (action == 'edit') {
      context.push('/home/create?edit=${listing.id}');
      return;
    }
    if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete listing?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      try {
        await ref.read(firestoreRepositoryProvider).deleteListing(listing.id);
        if (mounted) context.pop();
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(friendlyError(error))));
        }
      }
      return;
    }
    final status = switch (action) {
      'sold' => ListingStatus.sold,
      'swapped' => ListingStatus.swapped,
      'pending' => ListingStatus.reserved,
      'available' => ListingStatus.active,
      _ => null,
    };
    if (status == null) return;
    try {
      await ref
          .read(firestoreRepositoryProvider)
          .updateListingStatus(listing.id, status);
      ref.invalidate(listingProvider(listing.id));
      ref.invalidate(myListingsProvider);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(listingProvider(widget.listingId));
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(listingProvider(widget.listingId)),
        ),
        data: (listing) {
          if (listing == null) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Listing unavailable',
              message: 'This item may have been removed.',
            );
          }
          final isOwner = user?.uid == listing.sellerId;
          if (!isOwner && !_viewCounted) {
            _viewCounted = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(firestoreRepositoryProvider)
                  .incrementViewCount(listing.id)
                  .catchError((_) {});
            });
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: IconButton.filledTonal(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                actions: [
                  if (isOwner)
                    IconButton.filledTonal(
                      onPressed: () => _ownerAction(listing),
                      icon: const Icon(Icons.more_horiz_rounded),
                    )
                  else
                    IconButton.filledTonal(
                      onPressed: () => _report(listing),
                      icon: const Icon(Icons.flag_outlined),
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                  child: ListingGallery(listing: listing, height: 280),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.teal.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              labelForEnum(listing.type),
                              style: const TextStyle(
                                color: AppTheme.teal,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (user != null)
                            Consumer(
                              builder: (context, ref, _) {
                                final saved =
                                    ref
                                        .watch(favoriteProvider(listing.id))
                                        .value ??
                                    false;
                                return IconButton.filledTonal(
                                  onPressed: () => ref
                                      .read(firestoreRepositoryProvider)
                                      .setFavorite(
                                        user.uid,
                                        listing.id,
                                        !saved,
                                      ),
                                  icon: Icon(
                                    saved
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: saved ? AppTheme.coral : null,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        listing.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.8,
                            ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        formatListingPrice(listing),
                        style: const TextStyle(
                          fontSize: 25,
                          color: AppTheme.teal,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(
                              Icons.category_outlined,
                              size: 17,
                            ),
                            label: Text(labelForEnum(listing.category)),
                          ),
                          Chip(
                            avatar: const Icon(
                              Icons.auto_awesome_outlined,
                              size: 17,
                            ),
                            label: Text(labelForEnum(listing.condition)),
                          ),
                          Chip(
                            avatar: const Icon(
                              Icons.location_on_outlined,
                              size: 17,
                            ),
                            label: Text(listing.campus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'About this item',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        listing.description,
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(height: 1.45),
                      ),
                      if (listing.author != null ||
                          listing.courseCode != null ||
                          listing.isbn != null) ...[
                        const SizedBox(height: 18),
                        if (listing.author != null)
                          Text('Author: ${listing.author}'),
                        if (listing.courseCode != null)
                          Text('Course: ${listing.courseCode}'),
                        if (listing.isbn != null) Text('ISBN: ${listing.isbn}'),
                      ],
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.teal.withValues(
                              alpha: .12,
                            ),
                            backgroundImage: listing.sellerPhoto != null
                                ? NetworkImage(listing.sellerPhoto!)
                                : null,
                            child: listing.sellerPhoto != null
                                ? null
                                : Text(
                                    listing.sellerName.isEmpty
                                        ? '?'
                                        : listing.sellerName
                                              .substring(0, 1)
                                              .toUpperCase(),
                                    style: const TextStyle(
                                      color: AppTheme.teal,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 11),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Listed by',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                listing.sellerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            formatRelativeDate(listing.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${listing.viewCount} views · ${listing.favoriteCount} saved',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (!isOwner &&
                          listing.status == ListingStatus.active) ...[
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _actionBusy
                                    ? null
                                    : () => _messageSeller(listing),
                                icon: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                ),
                                label: const Text('Message seller'),
                              ),
                            ),
                            if (listing.type == ListingType.swap) ...[
                              const SizedBox(width: 10),
                              IconButton.filledTonal(
                                onPressed: () => _proposeSwap(listing),
                                icon: const Icon(Icons.swap_horiz_rounded),
                                tooltip: 'Propose swap',
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
