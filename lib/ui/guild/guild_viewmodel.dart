import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/guild.dart';
import 'package:guild_chat/models/data_state.dart';
import 'package:guild_chat/data/guild_repository.dart';

class GuildViewmodel extends ChangeNotifier {
  // A mock list of chats in the guild
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
    // _guildChats = await fetchChatsFromDB();
    notifyListeners();
  }
}

// I"m going to try to comment the shit out of this.
// This is the guild notifier class. Notifiers are a
// class that manages mutable state, i.e. we expect
// to have mutator functions in this beast
class GuildNotifier extends Notifier<DataState<Guild>> {
  // First we set the the state, we will update this later so that we can
  // appropriately get a guild here. That way we will be able to
  // properly include a delete function
  @override
  DataState<Guild> build() {
    return DataState.initalize();
  }

  // This is our fist state mutator, as we can see, it specifically updates state
  // This is why we are useing a Notifier instead of a provider
  // We will add some providers above to get specicfic data we aren't
  // trying to mutate later
  Future<void> create({String name = '', String owner = ''}) async {
  state = DataState<Guild>.loading();

    try {
      Guild? guild = await GuildRepository.create(
        guildName: name,
        ownerId: owner,
      );
      if (guild != null) state = DataState<Guild>.success(guild);

      // Here we have to use the ?. operator because it is possible
      // for guildname to be null, though that should never be the
      // case here
      debugPrint("Created Guild with name: ${guild?.guildName}");
    } catch (e) {
      state = DataState<Guild>.error(e.toString());
    }
  }

  // TODO write an add user function
  // This will add a user to the list of users that subscribe to the guild
  // Future<void> addUser(String userId) {

  // }
  //

  // TODO write a remove user function
  // For when a user wants to leave a guild
  // Future<void> removeUser(String userId) {

  // }

  // TODO write a delete guild function
  // To complete burn a guild down, not a function we want to consider
  // To do this properly, we need to modify each user so the guild
  // no longer shows up for them, this is a big advantage of using a
  // guild_user table for this
  // Future<void> delete(String userId) {

  // }

  // TODO write a update guild function
  // This is a big maybe, this isn't applicable UNLESS
  // 1. We add a display name that can be updated
  // 2. We want to add a method to give ownership to someone else
  // Future<void> update(String userId) {

  // }
}
