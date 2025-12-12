import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/login/login_provider.dart';
import 'package:guild_chat/ui/homepage/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
  final title = 'Guild Chat';
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Make sure the user is logged 
    ref.read(authServiceProvider).checkSession();

    // Get the home screen provider
    final homeState = ref.watch(homeScreenProvider);

    final guilds = homeState.userGuilds;
    final email = homeState.userEmail;

    debugPrint("guilds: $guilds");

    return Scaffold(
      //creates top bar with navigation
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          //settings button to transfer to user settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/user_profile/$email');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //this segment displays the guilds with functionality to bring the users to that guilds page
          children: <Widget>[
            Expanded(
              child: guilds.isEmpty 
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                   child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_add,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "You haven't joined a guild yet!\n\nClick Find Guild or Create Guild below.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : ListView(
                children: guilds.map((guildName) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.group, size: 30),
                      ),
                      title: Text(
                        guildName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onTap: () {
                        //temp page switch logic
                        context.push('/guild/$guildName');
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      //this segment is for the bottom navigation settings, find guild and create guild
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                context.push('/guild/find');
              },
              label: const Text('Find Guild'),
              icon: const Icon(Icons.search),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              onPressed: () {
                context.push('/guild/create');
              },
              label: const Text('Create Guild'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
