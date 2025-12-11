import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/chat/chat_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    //title likely to be switched to guild name in future
    required this.chatName,
    required this.viewModel,
  });

  final String chatName;
  //this contains the guild_viewmodel data
  final ChatViewmodel viewModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }
  //top navigation pannel construction
  @override
  Widget build(BuildContext context) {
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
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.viewModel.chatMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = widget.viewModel.chatMessages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        chatMessage[0], // Name
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4.0), // Indent the message
                        child: Text(
                          chatMessage[1], // Message
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
