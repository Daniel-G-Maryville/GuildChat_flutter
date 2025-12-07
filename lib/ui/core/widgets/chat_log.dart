import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/core/widgets/chat_message.dart';
import 'package:guild_chat/ui/core/widgets/chat_notifier.dart';

class ChatLog extends ConsumerStatefulWidget {
  const ChatLog({super.key});

  @override
  ConsumerState<ChatLog> createState() => _ChatLogState();
}

class _ChatLogState extends ConsumerState<ChatLog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatLogProvider);

    ref.listen(chatLogProvider, (previous, next) {
      if (next.length > (previous?.length ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && _scrollController.offset < 300) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    return ListView.builder(
      reverse: true,
      controller: _scrollController,
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 80,
      ), // room for FAB/input later
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msgIndex = messages.length - 1 - index;
        return ChatMessage(data: messages[msgIndex]);
      },
    );
  }
}
