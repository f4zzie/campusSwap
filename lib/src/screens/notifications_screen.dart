import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () {
                final uid = ref.read(currentUserProvider)?.uid;
                if (uid != null) {
                  ref
                      .read(firestoreRepositoryProvider)
                      .markAllNotificationsRead(uid);
                }
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyState(
                icon: Icons.notifications_none_rounded,
                title: "You're all caught up",
                message: 'Messages and swap updates will show up here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) =>
                    _NotificationTile(notification: items[index]),
              ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: AppTheme.teal.withValues(alpha: .12),
        child: Icon(_iconFor(notification.type), color: AppTheme.teal),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.read ? FontWeight.w600 : FontWeight.w900,
        ),
      ),
      subtitle: Text(
        notification.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatRelativeDate(notification.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        final uid = ref.read(currentUserProvider)?.uid;
        if (uid != null && !notification.read) {
          ref
              .read(firestoreRepositoryProvider)
              .markNotificationRead(uid, notification.id);
        }
        final route = _routeFor(notification);
        if (route != null) context.push(route);
      },
    );
  }

  IconData _iconFor(NotificationType type) => switch (type) {
    NotificationType.message => Icons.chat_bubble_outline_rounded,
    NotificationType.swapRequest => Icons.swap_horiz_rounded,
    NotificationType.swapAccepted => Icons.check_circle_outline_rounded,
    NotificationType.swapDeclined => Icons.cancel_outlined,
    NotificationType.listingSold => Icons.sell_outlined,
    NotificationType.listingSwapped => Icons.swap_horizontal_circle_outlined,
    NotificationType.system => Icons.info_outline_rounded,
  };

  String? _routeFor(AppNotification notification) {
    final id = notification.relatedId;
    if (id == null) return null;
    return switch (notification.type) {
      NotificationType.message => '/home/chat/$id',
      NotificationType.swapRequest ||
      NotificationType.swapAccepted ||
      NotificationType.swapDeclined => '/home/swaps',
      NotificationType.listingSold ||
      NotificationType.listingSwapped => '/home/listing/$id',
      NotificationType.system => null,
    };
  }
}
