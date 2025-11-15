import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Assuming db is a global or injected Firestore instance
final db = FirebaseFirestore.instance;

class User {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;

  // Constructor for creating a new User (e.g., for adding)
  User({this.username, this.firstName, this.lastName, this.email});

  // Factory constructor to create User from Firestore document
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      username: map['username'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      email: map['email'] as String?,
    )..id = id;
  }

  // Get a user by ID from Firestore
  static Future<User?> getUserById(String userId) async {
    try {
      final docSnapshot = await db.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return User.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
    }
    return null;
  }

  // Get all users from Firestore
  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await db.collection('users').get();
      return querySnapshot.docs.map((doc) {
        return User.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      rethrow;
    }
  }

  // Add a new user to Firestore (instance method to match your original usage)
  Future<User?> addUser(String username, {String? email}) async {
    try {
      final docRef = await db.collection('users').add({
        'username': username,
        'firstName': null, // Or default values
        'lastName': null,
        'email': email ?? this.email, // Use provided email or instance's email
      });
      id = docRef.id;
      return this;
    } catch (e) {
      debugPrint('Error adding user: $e');
    }
    return null;
  }

  // Delete this user from Firestore
  Future<void> delete() async {
    if (id == null) {
      throw ArgumentError('Cannot delete a user without an id');
    }
    try {
      await db.collection('users').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  // Update this user in Firestore
  Future<bool> update() async {
    if (id == null) {
      throw ArgumentError('Cannot update a user without an id');
    }
    try {
      await db.collection('users').doc(id).update({
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }
}
