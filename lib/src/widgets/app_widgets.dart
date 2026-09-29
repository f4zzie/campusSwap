import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../providers.dart';

/// Kenyan shilling formatter, e.g. `KSh 1,500`. Currency lives here so the
/// symbol is never hardcoded at call sites.
final _currencyFormat = NumberFormat.currency(symbol: 'KSh ', decimalDigits: 0);

String formatPrice(num amount) => _currencyFormat.format(amount);

String formatListingPrice(Listing listing) {
  if (listing.type == ListingType.free) return 'Free';
  return formatPrice(listing.price);
}

String formatRelativeDate(DateTime date) {
  final difference = DateTime.now().difference(date);
  if (difference.inMinutes < 1) return 'just now';
  if (difference.inHours < 1) return '${difference.inMinutes}m ago';
  if (difference.inDays < 1) return '${difference.inHours}h ago';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  return DateFormat('MMM d').format(date);
}

String labelForEnum(Object value) {
  final raw = value.toString().split('.').last;
  return raw == 'newItem'
      ? 'New'
      : raw[0].toUpperCase() +
            raw
                .substring(1)
                .replaceAllMapped(
                  RegExp(r'([A-Z])'),
                  (match) => ' ${match.group(1)}',
                );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 42,
          height: compact ? 34 : 42,
          decoration: BoxDecoration(
            color: AppTheme.teal,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 10),
          Text(
            'CampusSwap',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
              color: AppTheme.ink,
            ),
          ),
        ],
      ],
    );
  }
}

class ListingImage extends StatelessWidget {
  const ListingImage({super.key, required this.listing, this.height = 180});

  final Listing listing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = listing.imageUrls.isEmpty ? null : listing.imageUrls.first;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: url == null
            ? Container(
                color: AppTheme.teal.withValues(alpha: .1),
                child: Icon(
                  _iconForCategory(listing.category),
                  size: 54,
                  color: AppTheme.teal.withValues(alpha: .7),
                ),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: AppTheme.teal.withValues(alpha: .08),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppTheme.teal.withValues(alpha: .1),
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
      ),
    );
  }

  IconData _iconForCategory(ListingCategory category) {
    return switch (category) {
      ListingCategory.textbooks => Icons.menu_book_rounded,
      ListingCategory.electronics => Icons.devices_other_rounded,
      ListingCategory.dorm => Icons.chair_rounded,
      ListingCategory.clothing => Icons.checkroom_rounded,
      ListingCategory.supplies => Icons.backpack_rounded,
      ListingCategory.other => Icons.category_rounded,
    };
  }
}

class ListingCard extends ConsumerWidget {
  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onFavorite,
  });

  final Listing listing;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(favoriteProvider(listing.id)).value ?? false;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ListingImage(listing: listing, height: 128),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filledTonal(
                      onPressed: onFavorite,
                      icon: Icon(
                        saved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 19,
                        color: saved ? AppTheme.coral : null,
                      ),
                      tooltip: saved ? 'Saved' : 'Save listing',
                    ),
                  ),
                  if (listing.type == ListingType.swap)
                    const Positioned(bottom: 8, left: 8, child: _SwapBadge()),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                listing.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                formatListingPrice(listing),
                style: const TextStyle(
                  color: AppTheme.teal,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    size: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      labelForEnum(listing.condition),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (listing.courseCode != null) ...[
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        listing.courseCode!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.sellerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatRelativeDate(listing.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 55, color: AppTheme.teal.withValues(alpha: .55)),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48),
            const SizedBox(height: 14),
            const Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 7),
            Text(
              friendlyError(error),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SwapBadge extends StatelessWidget {
  const _SwapBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.coral,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.swap_horiz_rounded, size: 13, color: Colors.white),
          SizedBox(width: 3),
          Text(
            'Swap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Swipeable photo gallery for the listing detail screen. Falls back to a
/// category placeholder when a listing has no images.
class ListingGallery extends StatefulWidget {
  const ListingGallery({super.key, required this.listing, this.height = 300});

  final Listing listing;
  final double height;

  @override
  State<ListingGallery> createState() => _ListingGalleryState();
}

class _ListingGalleryState extends State<ListingGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.listing.imageUrls;
    if (urls.length <= 1) {
      return ListingImage(listing: widget.listing, height: widget.height);
    }
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (value) => setState(() => _page = value),
              itemCount: urls.length,
              itemBuilder: (_, index) => CachedNetworkImage(
                imageUrl: urls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, _) => Container(
                  color: AppTheme.teal.withValues(alpha: .08),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppTheme.teal.withValues(alpha: .1),
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(urls.length, (index) {
            final active = index == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active
                    ? AppTheme.teal
                    : AppTheme.teal.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

String friendlyError(Object error) {
  final text = error.toString();
  if (text.contains('email-already-in-use'))
    return 'That email is already registered.';
  // Google sign-in keeps its real failure code (see AuthRepository), so a
  // configuration problem reads as one instead of a generic retry message.
  if (text.contains('google-sign-in-missing-id-token') ||
      text.contains('google-sign-in-clientConfigurationError') ||
      text.contains('google-sign-in-providerConfigurationError')) {
    return 'Google sign-in is not set up for this build yet. Please use email sign-in.';
  }
  if (text.contains('google-sign-in-interrupted'))
    return 'Google sign-in was interrupted. Please try again.';
  if (text.contains('cancelled')) return 'Google sign-in was cancelled.';
  if (text.contains('google-sign-in-'))
    return 'Google sign-in could not be completed. Please use email sign-in.';
  if (text.contains('invalid-credential') || text.contains('wrong-password')) {
    return 'The email or password is incorrect.';
  }
  if (text.contains('weak-password')) return 'Choose a stronger password.';
  if (text.contains('network-request-failed'))
    return 'Check your internet connection and try again.';
  // Firestore write failures currently all collapse into the generic message
  // below, which hides what actually went wrong. Surface the common codes so
  // rule / index problems are diagnosable from the UI.
  if (text.contains('permission-denied') || text.contains('PERMISSION_DENIED'))
    return 'Permission denied by the server. Your account may not be allowed to do this yet.';
  if (text.contains('failed-precondition') ||
      text.contains('FAILED_PRECONDITION') ||
      text.contains('requires an index'))
    return 'The server is missing a database index for this request. Please try again shortly.';
  if (text.contains('unavailable') || text.contains('UNAVAILABLE'))
    return 'Can\'t reach the server right now. Please try again.';
  return 'We could not complete that action. Please try again.';
}
