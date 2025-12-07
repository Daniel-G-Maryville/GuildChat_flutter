import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatLogProvider = NotifierProvider<ChatLogNotifier, List<Map<String, String>>>(
  ChatLogNotifier.new,
);

class ChatLogNotifier extends Notifier<List<Map<String, String>>> {
  @override
  List<Map<String, String>> build() => [];

  void addMessage(Map<String, String> data) {
    state = [...state, data];
  }

  void loadInitial(List<Map<String, String>> messages) {
    state = messages;
  }
}