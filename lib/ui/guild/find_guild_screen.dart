import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/models/guild.dart';
import 'package:guild_chat/data/guild_repository.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';
import 'package:guild_chat/ui/login/login_provider.dart';
import 'package:guild_chat/ui/user_profile/user_profile_provider.dart';

class FindGuildScreen extends ConsumerStatefulWidget {

  const FindGuildScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  ConsumerState<FindGuildScreen> createState() => _FindGuildScreenState();
}

class _FindGuildScreenState extends ConsumerState<FindGuildScreen> {
  //this variable is for holding the list of all the guilds
  late Future<List<Guild>> _guildsFuture;
  final _guildNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _guildsFuture = GuildRepository.getAllguilds();
  }

  @override
  void dispose() {
    _guildNameController.dispose();
    super.dispose();
  }

  //this function is designed to search if the name input is in the guild list
  //it will then handle the processing after
  void _findGuild() async {
    final searchTerm = _guildNameController.text.trim();

    //check if there is text
    if (searchTerm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a guild name.')),
      );
      return;
    }

    //get necessary user info
    final authState = ref.read(authNotifierProvider);
    final userProfileState = ref.read(userProfileNotifierProvider);
    final email = authState.email;
    
    while (userProfileState.data == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    final userGuilds = userProfileState.data?.guilds ?? [];

    //check if user has email
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to join a guild.')),
      );
      return;
    }

    //check guilds list to see if input is a guild name
    final guilds = await _guildsFuture;
    Guild? foundGuild;
    try {
      foundGuild = guilds.firstWhere(
        (guild) => guild.guildName.toLowerCase() == searchTerm.toLowerCase(),
      );
    } catch (e) {
      foundGuild = null;
    }

    //finalize process by adding user to guild if name is a guild.
    //adds user to guild user list and adds guild to guilds user list
    if (foundGuild != null) {
      if (userGuilds.contains(foundGuild.guildName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'You are already a member of "${foundGuild.guildName}".')),
        );
        return;
      }

      await ref
          .read(guildNotifierProvider.notifier)
          .addUser(foundGuild.guildName, email);
          
      await ref
            .read(userProfileNotifierProvider.notifier)
            .addGuild(foundGuild.guildName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully joined "${foundGuild.guildName}"!')),
      );

      // Delay the pop to allow the snackbar to be visible before navigating back
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        context.pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guild "$searchTerm" not found.')),
      );

    }
  }

  //top navigation pannel construction
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //this holds the textbox and button to later control the finding of a guild
          children: [
            TextField(
              controller: _guildNameController,
              decoration: const InputDecoration(labelText: 'Guild Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _findGuild,
              child: const Text('Find and Join Guild'),
            ),
          ]
        ),
      ),
    );
  }
}
