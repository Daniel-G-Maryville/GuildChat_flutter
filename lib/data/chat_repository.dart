import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:guild_chat/models/chat_channel.dart';
import 'package:guild_chat/models/chat_message.dart';

class ChatMessageRepository {
  static const mainChat = 'main_chat';
  static const guilds = 'guilds';
  static const chatChannels = 'chat_channels';
  static const messages = 'messages';

  Future<void> sendMessage({
    required String guildName,
    required String username,
    required String text,
    String? channel,
  }) async {
    if (text.trim().isEmpty) return;

    channel = channel ?? mainChat;

    final messagesRef = FirebaseFirestore.instance
        .collection(guilds)
        .doc(guildName)
        .collection(chatChannels)
        .doc(channel)
        .collection(messages);

    final chat = ChatMessage.create(username: username, message: text);

    await messagesRef.add(chat.toMap());
  }

  Stream<List<ChatMessage>> mainChatStream(
    String guildName, {
    String channel = mainChat,
  }) {
    return FirebaseFirestore.instance
        .collection(guilds)
        .doc(guildName)
        .collection(chatChannels)
        .doc(channel)
        .collection(messages)
        .orderBy('created', descending: true)
        .limitToLast(100)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<bool> createChannel(
    String guildName, {
    String? channelName = mainChat,
  }) async {
    bool res = true;
    try {
      await FirebaseFirestore.instance
          .collection(guilds)
          .doc(guildName)
          .collection(chatChannels)
          .doc(channelName)
          .set({
            'created': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error: $e");
      res = false;
    }
    return res;
  }

  static Future<List<ChatChannel>> getChatChannels(String guildName) async {
    final query = await FirebaseFirestore.instance
        .collection(guilds)
        .doc(guildName)
        .collection(chatChannels)
        .get();

    return query.docs.map((doc) {
      debugPrint("firestore doc:  ${doc.id}");
      return ChatChannel.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
