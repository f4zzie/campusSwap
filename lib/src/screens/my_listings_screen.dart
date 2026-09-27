import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';
import 'home_shell.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(myListingsProvider);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(
              child: PageHeader(
                title: 'Your listings',
                subtitle: 'Manage what you have out in the world.',
              ),
            ),
          ),
          listings.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) =>
                SliverFillRemaining(child: ErrorState(error: error)),
            data: (items) => items.isEmpty
                ? SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.sell_outlined,
                      title: 'Nothing listed yet',
                      message: 'Have something another student needs? List it in under a minute.',
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) =>
                          _MyListingTile(listing: items[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MyListingTile extends ConsumerWidget {
  const _MyListingTile({required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = listing.status == ListingStatus.active
        ? AppTheme.teal
        : Colors.grey;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => context.push('/home/listing/${listing.id}'),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: ListingImage(listing: listing, height: 100),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatListingPrice(listing),
                      style: const TextStyle(
                        color: AppTheme.teal,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        labelForEnum(listing.status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
