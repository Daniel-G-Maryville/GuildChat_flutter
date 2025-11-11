import 'package:cloud_firestore/cloud_firestore.dart';

class DataHelpers {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void addUser(username, password) async {
    final user = <String, dynamic>{
      'username': username,
      'password': password,
    };
    await db.collection('users').add(user);
  }
}