import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/core/widgets/chat_log.dart';
import 'package:guild_chat/ui/core/widgets/chat_notifier.dart';

// class ChatDemo extends StatelessWidget {
//   const ChatDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(title: const Text('Single Chat Message Demo')),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: ChatMessage(
//             data: {
//               'avatar': 'https://i.pravatar.cc/150?img=12', // random avatar
//               'username': 'Alice',
//               'message':
//                   'Hey! This is a test message to see how the chat widget looks with a longer text that wraps properly across multiple lines.',
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class ChatDemo extends ConsumerWidget {
  const ChatDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Chat Log Demo')),
      body: const ChatLog(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final rand = Random();
          final usernames = ['Alice', 'Bob', 'Charlie', 'Dave', 'Eve'];
          final texts = [
            'Hello!',
            'How\'s it going?',
            'Nice!',
            'Testing 1 2 3',
            'This is a much longer test message that will wrap over several lines to demonstrate the layout.',
            '😂',
            'See ya',
          ];

          ref.read(chatLogProvider.notifier).addMessage({
            'avatar': 'https://i.pravatar.cc/150?img=${rand.nextInt(70) + 1}',
            'username': usernames[rand.nextInt(usernames.length)],
            'message': texts[rand.nextInt(texts.length)],
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
