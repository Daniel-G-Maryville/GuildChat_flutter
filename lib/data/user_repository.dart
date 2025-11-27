import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/user_profile.dart'; // Import the model

// Assuming db is a global or injected Firestore instance
final db = FirebaseFirestore.instance;
final collection = 'user_profile';
final guildCollection = 'guilds';

class UserRepository {
  // Get a user by email (document ID assumed to be email)
  static Future<UserProfile?> getUserByEmail(String email) async {
    try {
      final docSnapshot = await db.collection(collection).doc(email).get();
      if (docSnapshot.exists) {
        return UserProfile.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
    } catch (e) {
      debugPrint('Error getting user by email: $e');
    }
    return null;
  }

  // Get all users from Firestore
  static Future<List<UserProfile>> getAllUsers() async {
    try {
      final querySnapshot = await db.collection(collection).get();
      return querySnapshot.docs.map((doc) {
        return UserProfile.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      rethrow;
    }
  }

  // Create a new userProfile in Firestore (using email as document ID)
  static Future<UserProfile?> create({
    String email = '',
    String username = '',
    String firstName = '',
    String lastName = '',
    List<String> guilds = const [],
  }) async {
    try {
      final newUser = UserProfile(
        username: username.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.toLowerCase().trim(),
        guilds: guilds,
      );
      debugPrint("Trying to create the UserProfile: $newUser");
      await db.collection(collection).doc(email).set(newUser.toMap());
      debugPrint("Created new UserProfile");
      return newUser;
    } catch (e) {
      debugPrint('Error creating user: $e');
    }
    return null;
  }

  // Delete a user by ID from Firestore
  static Future<void> delete(String email) async {
    try {
      await db.collection(collection).doc(email).delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  // Update a user in Firestore
  static Future<bool> update({
    String email = '',
    String username = '',
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      await db.collection(collection).doc(email).update({
        'firstName': firstName.trim(),
        'username': username.trim(),
        'lastName': lastName.trim(),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  // Add guild to user
  static Future<bool> addGuild(String email, String guild) async {
    try {
      await db.collection(collection).doc(email).update({
        guildCollection: FieldValue.arrayUnion([guild]),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating guild: $e');
      return false;
    }
  }

  // Remove member from guild
  static Future<bool> removeMember(String email, String guild) async {
    try {
      await db.collection(collection).doc(email).update({
        guildCollection: FieldValue.arrayRemove([guild]),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating guild: $e');
      return false;
    }
  }
}
