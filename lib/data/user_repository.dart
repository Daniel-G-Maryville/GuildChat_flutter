import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/user.dart';  // Import the model

// Assuming db is a global or injected Firestore instance
final db = FirebaseFirestore.instance;

class UserRepository {
  // Get a user by email (document ID assumed to be email)
  static Future<User?> getUserByEmail(String email) async {
    try {
      final docSnapshot = await db.collection('users').doc(email).get();
      if (docSnapshot.exists) {
        return User.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
    } catch (e) {
      debugPrint('Error getting user by email: $e');
    }
    return null;
  }

  // Get all users from Firestore
  static Future<List<User>> getAllUsers() async {
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

  // Create a new user in Firestore (using email as document ID)
  static Future<User?> create({
    String email = '', 
    String username = '',
    String firstName = '',
    String lastName = ''
  }) async {
    try {
      final newUser = User(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      await db.collection('users').doc(email).set(newUser.toMap());
      return newUser;
    } catch (e) {
      debugPrint('Error creating user: $e');
    }
    return null;
  }

  // Delete a user by ID from Firestore
  static Future<void> delete(String id) async {
    try {
      await db.collection('users').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  // Update a user in Firestore
  static Future<bool> update(User user) async {
    try {
      await db.collection('users').doc(user.email).update(user.toMap());
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }
}