import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/guild.dart'; // Import the model

// Assuming db is a global or injected Firestore instance
final db = FirebaseFirestore.instance;
final collection = 'guild';
final memberCollection = 'members';

class GuildRepository {
  // Get a guild by name (document ID assumed to be email)
  static Future<Guild?> getGuildByName(String name) async {
    try {
      final docSnapshot = await db.collection(collection).doc(name).get();
      if (docSnapshot.exists) {
        return Guild.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
    } catch (e) {
      debugPrint('Error getting guild by name: $e');
    }
    return null;
  }

  // Get all guilds from Firestore
  static Future<List<Guild>> getAllguilds() async {
    try {
      final querySnapshot = await db.collection(collection).get();
      return querySnapshot.docs.map((doc) {
        return Guild.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting guilds: $e');
      rethrow;
    }
  }

  // Create a new guild in Firestore (using email as document ID)
  static Future<Guild?> create({
    String guildName = '',
    String ownerId = '',
    List<String> members = const [],
  }) async {
    try {
      final newguild = Guild(
        guildName: guildName,
        ownerId: ownerId,
        members: members,
      );
      await db.collection(collection).doc(guildName).set(newguild.toMap());
      return newguild;
    } catch (e) {
      debugPrint('Error creating guild: $e');
    }
    return null;
  }

  // Delete a guild by ID from Firestore
  static Future<void> delete(String name) async {
    try {
      await db.collection(collection).doc(name).delete();
    } catch (e) {
      debugPrint('Error deleting guild: $e');
    }
  }

  // Add Member to guild
  static Future<bool> addMember(String guildName, String member) async {
    try {
      await db.collection(collection).doc(guildName).update({
        memberCollection: FieldValue.arrayUnion([member]),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating guild: $e');
      return false;
    }
  }

  // Remove member from guild
  static Future<bool> removeMember(String guildName, String member) async {
    try {
      await db.collection(collection).doc(guildName).update({
        memberCollection: FieldValue.arrayRemove([member]),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating guild: $e');
      return false;
    }
  }
}
