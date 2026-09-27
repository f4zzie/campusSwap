import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import '../widgets/app_widgets.dart';
import 'home_shell.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(favoritesProvider);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(
              child: PageHeader(
                title: 'Saved finds',
                subtitle: 'Keep an eye on the things you like.',
              ),
            ),
          ),
          saved.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) =>
                SliverFillRemaining(child: ErrorState(error: error)),
            data: (items) => items.isEmpty
                ? const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.favorite_border_rounded,
                      title: 'Nothing saved yet',
                      message: 'Tap the heart on a listing to save it here.',
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: .58,
                          ),
                      itemCount: items.length,
                      itemBuilder: (_, index) => ListingCard(
                        listing: items[index],
                        onTap: () =>
                            context.push('/home/listing/${items[index].id}'),
                        onFavorite: () => ref
                            .read(firestoreRepositoryProvider)
                            .setFavorite(
                              ref.read(currentUserProvider)!.uid,
                              items[index].id,
                              false,
                            ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
