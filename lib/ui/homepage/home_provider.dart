import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/user_profile/user_profile_provider.dart';
//import 'package:guild_chat/models/user.dart'; // Uncomment when needed

class HomeViewmodel {
  // A mock list of guilds the user is a part of.
  // Later, this would be fetched from your database.
  final List<String> _userGuilds = [
    'The Flutter Wizards',
    'Dart Demons',
    'The State Managers',
    'Pixel Perfect Crew',
  ];

  List<String> get userGuilds => List.unmodifiable(_userGuilds);
}

final homeScreenProvider = Provider<HomeViewmodel>((ref) => HomeViewmodel());
