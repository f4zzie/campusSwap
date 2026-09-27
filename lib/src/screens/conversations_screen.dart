import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';
import 'home_shell.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(
              child: PageHeader(
                title: 'Your inbox',
                subtitle: 'Keep conversations in one place.',
              ),
            ),
          ),
          conversations.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverFillRemaining(
              child: ErrorState(
                error: error,
                onRetry: () => ref.invalidate(conversationsProvider),
              ),
            ),
            data: (items) => items.isEmpty
                ? const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.forum_outlined,
                      title: 'No conversations yet',
                      message: 'Message a seller to talk about an item.',
                    ),
                  )
                : SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) =>
                        _ConversationTile(conversation: items[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  const _ConversationTile({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUserProvider)?.uid;
    final otherName = conversation.sellerId == uid
        ? conversation.buyerName
        : conversation.sellerName;
    final count = conversation.unreadCounts[uid] ?? 0;
    final unread = count > 0 || conversation.unreadBy.contains(uid);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          otherName.isEmpty ? '?' : otherName.substring(0, 1).toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      title: Text(
        otherName,
        style: TextStyle(
          fontWeight: unread ? FontWeight.w900 : FontWeight.w700,
        ),
      ),
      subtitle: Text(
        conversation.lastMessage.isEmpty
            ? conversation.listingTitle
            : conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatRelativeDate(conversation.lastMessageAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (unread) ...[
            const SizedBox(height: 5),
            Container(
              constraints: const BoxConstraints(minWidth: 20),
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                count > 0 ? '$count' : '•',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () => context.push('/home/chat/${conversation.id}'),
    );
  }
}
