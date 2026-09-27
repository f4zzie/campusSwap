import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';

class SwapScreen extends ConsumerWidget {
  const SwapScreen({super.key});

  Future<void> _respond(
    BuildContext context,
    WidgetRef ref,
    SwapProposal swap,
    SwapStatus status,
  ) async {
    try {
      await ref.read(firestoreRepositoryProvider).respondToSwap(swap, status);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == SwapStatus.accepted
                  ? 'Swap accepted.'
                  : 'Swap declined.',
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    }
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    SwapProposal swap,
  ) async {
    try {
      await ref.read(firestoreRepositoryProvider).cancelSwap(swap.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Swap proposal cancelled.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swaps = ref.watch(swapsProvider);
    final uid = ref.watch(currentUserProvider)?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Swap proposals')),
      body: swaps.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(error: error),
        data: (items) => items.isEmpty
            ? const EmptyState(
                icon: Icons.swap_horizontal_circle_outlined,
                title: 'No proposals yet',
                message:
                    'When you propose or receive a swap, it will show up here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final swap = items[index];
                  final received = swap.ownerId == uid;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.swap_horiz_rounded,
                                color: AppTheme.teal,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  swap.listingTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              _StatusBadge(status: swap.status),
                            ],
                          ),
                          const SizedBox(height: 13),
                          Text(
                            received
                                ? 'Someone proposed a swap for your listing.'
                                : 'You proposed a swap for this listing.',
                          ),
                          if (swap.offeredListingTitle != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              received
                                  ? 'Offering: ${swap.offeredListingTitle}'
                                  : 'You offered: ${swap.offeredListingTitle}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                          if (swap.message != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('“${swap.message}”'),
                            ),
                          ],
                          if (swap.status == SwapStatus.pending) ...[
                            const SizedBox(height: 14),
                            if (received)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _respond(
                                      context,
                                      ref,
                                      swap,
                                      SwapStatus.declined,
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton(
                                    onPressed: () => _respond(
                                      context,
                                      ref,
                                      swap,
                                      SwapStatus.accepted,
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                ],
                              )
                            else
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                  onPressed: () => _cancel(context, ref, swap),
                                  child: const Text('Cancel proposal'),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SwapStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == SwapStatus.accepted
        ? AppTheme.teal
        : status == SwapStatus.declined
        ? Theme.of(context).colorScheme.error
        : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        labelForEnum(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
