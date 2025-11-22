import 'package:flutter/foundation.dart';
//import 'package:guild_chat/models/user.dart'; // Uncomment when needed

class GuildViewmodel extends ChangeNotifier {
  // A mock list of guilds the user is a part of.
  // Later, this would be fetched from your database.
  final List<String> _guildChats = [
    'Newcomers',
    'Bombers',
    'Runners',
    'Testers',
  ];

  List<String> get guildChats => List.unmodifiable(_guildChats);

  // Example method to update guilds (e.g., from DB)
  Future<void> loadChats() async {
    // Simulate fetching from DB
    // _userGuilds = await fetchGuildsFromDB();
    notifyListeners();
  }
}