import 'package:cloud_firestore/cloud_firestore.dart';

class ChatChannel {
  final String channelName;
  final Timestamp created;
  final String id;

  ChatChannel._({
    required this.channelName,
    required this.created,
    required this.id}
  );

  factory ChatChannel.create({
    required String channelName,
  }) {
    return ChatChannel._(
      channelName: channelName,
      created: Timestamp.now(),
      id: '',
    );
  }

  factory ChatChannel.fromMap(Map<String, dynamic> data, String? id) {
    return ChatChannel._(
      channelName: data['guildName'] ?? '',
      created: data['created'] ?? Timestamp.now(),
      id: id ?? '',
    );
  }

  // This is what is sent to firestore,
  // note, we want the server to timestamp this on creation.
  Map<String, dynamic> toMap() {
    return {
      'channelName': channelName,
      'created': FieldValue.serverTimestamp(),
    };
  }
}
