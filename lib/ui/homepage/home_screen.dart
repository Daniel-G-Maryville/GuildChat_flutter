import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/homepage/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final String title;
  //holds the home_viewmodel data
  final HomeViewmodel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
              context.push('/user_profile/a@a.com');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //this segment displays the guilds with functionality to bring the users to that guilds page
          children: <Widget>[
            Expanded(
              child: ListView(
                children: widget.viewModel.userGuilds.map((guildName) {
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
                        context.push('/guild');
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
                // Replace with actual navigation, e.g., context.go('/find-guild');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Go to the Find Guild page')),
                );
              },
              label: const Text('Find Guild'),
              icon: const Icon(Icons.search),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              onPressed: () {
                // Replace with actual navigation, e.g., context.go('/create-guild');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Go to the Create Guild page')),
                );
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