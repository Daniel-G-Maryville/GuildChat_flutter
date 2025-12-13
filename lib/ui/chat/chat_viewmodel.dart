import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/data/chat_repository.dart';
import 'package:guild_chat/models/chat_message.dart';

final createChatChannelProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, displayName) async {
      final chatRepo = ChatMessageRepository();
      return await chatRepo.createChannel(displayName);
    });

class ChatMessageNotifier extends StreamNotifier<List<ChatMessage>> {
  final String guildName;
  final String channel;

  ChatMessageNotifier({
    required this.guildName,
    this.channel = ChatMessageRepository.mainChat,
  });

  @override
  Stream<List<ChatMessage>> build() {
    return ChatMessageRepository.mainChatStream(
      guildName,
      channel: channel,
    );
  }
}

final chatMessagesProvider = StreamNotifierProvider.family<
    ChatMessageNotifier,
    List<ChatMessage>,
    ({String guildId, String channel})>((params) {
  return ChatMessageNotifier(
    guildName: params.guildId,
    channel: params.channel,
  );
});