import 'package:flutter/material.dart';

// This class wraps a chat message
// ___________________________________
// |      | *User_name*              |
// |  img |  Message                 |
// |      |                          |
// ___________________________________

class ChatMessage extends StatelessWidget {
  final Map<String, String> data;

  const ChatMessage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = data['avatar'] ?? '';
    final String username = data['username'] ?? 'Anon';
    final String message = data['message'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? Text(username.isNotEmpty ? username[0].toUpperCase() : '?')
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    ); 
  }
}
