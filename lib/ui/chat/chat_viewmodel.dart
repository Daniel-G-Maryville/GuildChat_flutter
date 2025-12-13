import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/data/chat_repository.dart';

final createChatChannelProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, guildName) async {
  final chatRepo = ChatMessageRepository();
  return await chatRepo.createChannel(guildName);
});

class ChatViewmodel extends ChangeNotifier {
  // A mock list of messages in the chat
  // Later, this would be fetched from your database.
  final List<List<String>> _chatMessages = [
    ['Jeff', 'Did you see the planned event?'],
    ['Terry', 'No, where did you send it?'],
    ['Carl', 'Yea, the one you sent in the group text right?'],
    ['Jeff', 'Oh, right I forgot Terry is not in that group text'],
    ['Jeff', 'I will make sure to post event updates in here in the future'],
  ];

  List<List<String>> get chatMessages => List.unmodifiable(_chatMessages);

  // Example method to update messages (e.g., from DB)
  Future<void> loadMessages() async {
    // Simulate fetching from DB
    // _chatMessages = await fetchMessagesFromDB();
    notifyListeners();
  }
}
