import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/guild.dart'; // Import the model

// Assuming db is a global or injected Firestore instance
final db = FirebaseFirestore.instance;
final collection = 'guild';

class GuildRepository {
  // Get a user by email (document ID assumed to be email)
  static Future<Guild?> getGuildByName(String guild_name) async {
    try {
      final docSnapshot = await db.collection(collection).doc(guild_name).get();
      if (docSnapshot.exists) {
        return Guild.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
    } catch (e) {
      debugPrint('Error getting user by email: $e');
    }
    return null;
  }

  // Get all users from Firestore
  static Future<List<Guild>> getAllUsers() async {
    try {
      final querySnapshot = await db.collection(collection).get();
      return querySnapshot.docs.map((doc) {
        return Guild.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      rethrow;
    }
  }

  // Create a new user in Firestore (using email as document ID)
  static Future<Guild?> create({
    String email = '',
    String username = '',
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      final newUser = Guild(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email.toLowerCase().trim(),
      );
      await db.collection(collection).doc(email).set(newUser.toMap());
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
        username: username,
        firstName: firstName,
        lastName: lastName,
      });
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }
}
