import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:guild_chat/models/guild.dart';
import 'package:guild_chat/models/data_state.dart';
import 'package:guild_chat/data/guild_repository.dart';
import 'package:guild_chat/ui/chat/chat_viewmodel.dart';
import 'package:guild_chat/ui/user_profile/user_profile_provider.dart';

//added guildViewModelProvider to allow functionality for creating guild

final channelProvider = FutureProvider.autoDispose.family<String, String>(
  (guildName, channel) {
    
  },
);

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
      if (guild != null) {
        // 1. Create the main chant channel
        final chatCreated = ref.read(createChatChannelProvider(name));

        // 2. Add the created guild to the user's profile
        // We use ref.read here because we are calling a method on another provider
        // without listening to its state changes directly in this method.
        await ref
            .read(userProfileNotifierProvider.notifier)
            .addGuild(guild.guildName);

        // 3. Add the owner to the guilds members
        // This should be moved to a provider
        GuildRepository.addMember(name, owner);

        // 4. Set the final state to success
        state = DataState<Guild>.success(guild);
        debugPrint(
          "Created Guild with name: ${guild.guildName} and added to user profile.",
        );
      } else {
        throw Exception("Guild creation returned null.");
      }
    } catch (e) {
      state = DataState<Guild>.error(e.toString());
    }
  }

  // This will add a user to the list of users that subscribe to the guild
  Future<void> addUser(String guildName, String userId) async {
    try {
      GuildRepository.addMember(guildName, userId);
    } catch (e) {
      state = DataState<Guild>.error("Error: $e");
    }
  }
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

final guildNotifierProvider = NotifierProvider<GuildNotifier, DataState<Guild>>(
  () => GuildNotifier(),
);
