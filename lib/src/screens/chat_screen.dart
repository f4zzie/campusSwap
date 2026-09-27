import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _message = TextEditingController();
  final _scroll = ScrollController();
  final _picker = ImagePicker();
  bool _sending = false;
  bool _markScheduled = false;
  int _lastCount = 0;

  @override
  void dispose() {
    _message.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Conversation? _conversation(WidgetRef ref) {
    final items = ref.watch(conversationsProvider).value ?? const [];
    for (final item in items) {
      if (item.id == widget.conversationId) return item;
    }
    return null;
  }

  void _markReadIfNeeded(Conversation? conversation, String? uid) {
    if (conversation == null ||
        uid == null ||
        !conversation.unreadBy.contains(uid) ||
        _markScheduled) {
      return;
    }
    _markScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await ref
            .read(firestoreRepositoryProvider)
            .markConversationRead(widget.conversationId, uid);
      } finally {
        _markScheduled = false;
      }
    });
  }

  void _autoScroll(int count) {
    if (count == _lastCount) return;
    _lastCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String? _recipient(Conversation conversation, String uid) =>
      conversation.sellerId == uid
      ? conversation.buyerId
      : conversation.sellerId;

  Future<void> _send({String? imageUrl}) async {
    final text = _message.text.trim();
    final uid = ref.read(currentUserProvider)?.uid;
    final conversation = _conversation(ref);
    if ((text.isEmpty && imageUrl == null) ||
        uid == null ||
        conversation == null ||
        _sending) {
      return;
    }
    setState(() => _sending = true);
    if (imageUrl == null) _message.clear();
    try {
      await ref
          .read(firestoreRepositoryProvider)
          .sendMessage(
            conversationId: widget.conversationId,
            senderId: uid,
            senderName: ref.read(profileProvider).value?.displayName ?? '',
            text: imageUrl == null ? text : '',
            recipientId: _recipient(conversation, uid)!,
            imageUrl: imageUrl,
          );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (picked == null) return;
    setState(() => _sending = true);
    try {
      final url = await ref
          .read(storageRepositoryProvider)
          .uploadChatImage(
            conversationId: widget.conversationId,
            file: File(picked.path),
          );
      await _send(imageUrl: url);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider(widget.conversationId));
    final uid = ref.watch(currentUserProvider)?.uid;
    final conversation = _conversation(ref);
    _markReadIfNeeded(conversation, uid);
    final otherRead =
        conversation != null &&
        uid != null &&
        !conversation.unreadBy.contains(_recipient(conversation, uid));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          conversation?.listingTitle ?? 'Conversation',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorState(error: error),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Start the conversation',
                    message: 'Ask about pickup, condition, or availability.',
                  );
                }
                _autoScroll(items.length);
                final lastMine = items.last.senderId == uid;
                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  itemCount: items.length,
                  itemBuilder: (_, index) => _MessageBubble(
                    message: items[index],
                    mine: items[index].senderId == uid,
                    showSeen:
                        index == items.length - 1 && lastMine && otherRead,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _sending ? null : _sendImage,
                    icon: const Icon(Icons.image_outlined),
                    tooltip: 'Send a photo',
                  ),
                  Expanded(
                    child: TextField(
                      controller: _message,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Write a message...',
                        prefixIcon: Icon(Icons.chat_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : () => _send(),
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.mine,
    this.showSeen = false,
  });

  final Message message;
  final bool mine;
  final bool showSeen;

  @override
  Widget build(BuildContext context) {
    final hasImage = message.imageUrl != null;
    return Column(
      crossAxisAlignment: mine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * .78,
            ),
            margin: const EdgeInsets.only(bottom: 3),
            padding: hasImage
                ? const EdgeInsets.all(5)
                : const EdgeInsets.fromLTRB(15, 11, 15, 9),
            decoration: BoxDecoration(
              color: mine ? AppTheme.teal : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(mine ? 18 : 4),
                bottomRight: Radius.circular(mine ? 4 : 18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: message.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const SizedBox(
                        width: 180,
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                if (message.text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: hasImage ? 6 : 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: mine ? Colors.white : null,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 4, right: hasImage ? 6 : 0),
                  child: Text(
                    DateFormat('h:mm a').format(message.sentAt),
                    style: TextStyle(
                      color: mine ? Colors.white70 : Colors.black45,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showSeen)
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 6),
            child: Text(
              'Seen',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: AppTheme.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
