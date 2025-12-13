import 'package:cloud_firestore/cloud_firestore.dart';

class ChatChannel {
  final String id;
  final Timestamp created;
  final String displayName;

  ChatChannel._({
    required this.id,
    required this.created,
    required this.displayName,
  });

  static String nameToId(String name) {
    return name.toLowerCase().replaceAll(RegExp(' '), '_');
  }

  factory ChatChannel.create({required String displayName}) {
    String id = nameToId(displayName);
    return ChatChannel._(
      id: id,
      displayName: displayName,
      created: Timestamp.now(),
    );
  }

  factory ChatChannel.fromMap(Map<String, dynamic> data, String? idStr) {
    var chatChannel = ChatChannel._(
      created: data['created'] ?? Timestamp.now(),
      id: idStr ?? '',
      displayName: data['displayName'] ?? '',
    );
    return chatChannel;
  }

  // This is what is sent to firestore,
  // note, we want the server to timestamp this on creation.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displaName': displayName,
      'created': FieldValue.serverTimestamp(),
    };
  }
}
