import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/data/chat_repository.dart';
import 'package:guild_chat/ui/chat/chat_viewmodel.dart';
import 'package:guild_chat/ui/user_profile/user_profile_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String guildId;
  final String chatName;

  const ChatScreen({super.key, required this.guildId, required this.chatName});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    final userState = ref.watch(userProfileNotifierProvider);
    final name = userState.data?.username;

    while (name == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (text.isNotEmpty) {
      ChatMessageRepository().sendMessage(
        guildName: widget.guildId,
        username: name, // Replace with actual username logic
        text: text,
        channel: widget.chatName,
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = ref.watch(chatMessagesProvider((channel: widget.chatName, guildId: widget.guildId)));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(widget.chatName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              //replace with actual navigation logic in the future
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Go to chat settings page')),
              );
            },
          ),
        ],
      ),
      //construction of the view of messages to be scrolled through
      body: Column(
        children: [
          Expanded(
            child: messageStream.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (messages) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.username),
                      subtitle: Text(message.message),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
