import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Fields for user data
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;

  // Constructor
  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
  });

  // Factory to create User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'] as String,
      firstName: data['first_name'] as String? ?? '',
      lastName: data['last_name'] as String? ?? '',
    );
  }

  // Method to add a new user
  void addUser(String username, {String first = '', String last = ''}) async {
    final userData = <String, dynamic>{
      'username': username,
      'first_name': first,
      'last_name': last,
    };
    await db.collection('users').add(userData);
  }

  // Method to get all users
  Future<List<User>> getAllUsers() async {
    final QuerySnapshot snapshot = await db.collection('users').get();
    return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
  }

  // Method to delete a user by ID
  void deleteUser(String userId) async {
    await db.collection('users').doc(userId).delete();
  }

  // Optional: Instance method to delete self (if you have a User instance)
  void delete() async {
    if (id == null) {
      throw ArgumentError('Cannot delete a user without an ID');
    }
    deleteUser(id!);
  }
}
