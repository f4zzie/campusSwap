import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_theme.dart';
import '../providers.dart';
import 'conversations_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'my_listings_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const FavoritesScreen(),
      const ConversationsScreen(),
      const MyListingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: _index == 3
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/home/create'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Sell an item'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell_rounded),
            label: 'Selling',
          ),
        ],
      ),
    );
  }
}

class PageHeader extends ConsumerWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showProfile = true,
  });

  final String title;
  final String? subtitle;
  final bool showProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (showProfile) ...[
          _NotificationsButton(unread: ref.watch(unreadNotificationsProvider)),
          const SizedBox(width: 6),
          IconButton.filledTonal(
            onPressed: () => context.push('/home/profile'),
            icon: CircleAvatar(
              radius: 13,
              backgroundColor: AppTheme.teal.withValues(alpha: .15),
              backgroundImage: profile?.photoUrl != null
                  ? NetworkImage(profile!.photoUrl!)
                  : null,
              child: profile?.photoUrl != null
                  ? null
                  : Text(
                      (profile?.displayName ?? 'C')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.teal,
                      ),
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({required this.unread});

  final int unread;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () => context.push('/home/notifications'),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text('$unread'),
        child: const Icon(Icons.notifications_none_rounded, size: 20),
      ),
    );
  }
}
