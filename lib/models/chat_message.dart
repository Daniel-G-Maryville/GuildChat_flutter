import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String username;
  final String message;
  final String id;
  final Timestamp created;

  ChatMessage._({
    required this.username,
    required this.message,
    required this.created,
    required this.id,
  });

  factory ChatMessage.create({
    required String username,
    required String message,
  }) {
    return ChatMessage._(
      username: username,
      message: message,
      created: Timestamp.now(),
      id: '',
    );
  }

  factory ChatMessage.fromMap(Map<String, dynamic> data, String? id) {
    return ChatMessage._(
      username: data['username'] ?? '',
      message: data['message'] ?? '',
      created: data['created'] ?? Timestamp.now(),
      id: id ?? '',
    );
  }

  // This is what is sent to firestore, 
  // note, we want the server to timestamp this on creation.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'message': message,
      'created': FieldValue.serverTimestamp(),
    };
  }
}
