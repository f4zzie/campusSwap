import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import '../widgets/app_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final darkMode = ref.watch(themeModeProvider);
    final listingCount = ref.watch(myListingsProvider).value?.length ?? 0;
    final unread = ref.watch(unreadNotificationsProvider);
    final photoUrl = profile?.photoUrl;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl != null
                            ? null
                            : Text(
                                (profile?.displayName ?? 'C')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.displayName ?? 'CampusSwap student',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(profile?.email ?? ''),
                            if (profile?.university != null)
                              Text(
                                profile!.university,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ProfileStat(label: 'Listings', value: '$listingCount'),
                      _ProfileStat(
                        label: 'Rating',
                        value: (profile?.ratingCount ?? 0) == 0
                            ? '—'
                            : (profile!.rating).toStringAsFixed(1),
                      ),
                      _ProfileStat(
                        label: 'Reviews',
                        value: '${profile?.ratingCount ?? 0}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/home/profile/edit'),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_none_rounded),
                  title: const Text('Notifications'),
                  subtitle: const Text('Messages, swaps, and updates'),
                  trailing: unread > 0
                      ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary,
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      : const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/home/notifications'),
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horizontal_circle_outlined),
                  title: const Text('Swap proposals'),
                  subtitle: const Text('Review offers and manage trades'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/home/swaps'),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  trailing: Switch(
                    value: darkMode,
                    onChanged: (_) => ref
                        .read(themeModeProvider.notifier)
                        .update((value) => !value),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () => ref.read(authRepositoryProvider).signOut(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Safety first',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          const Text(
            'Meet in a public campus location, check your item before exchanging, and never share passwords or financial details in chat.',
          ),
          const SizedBox(height: 20),
          const BrandMark(compact: true),
          const SizedBox(height: 6),
          Text(
            'Buy. Sell. Swap. Campus.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
