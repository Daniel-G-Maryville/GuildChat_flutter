import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';

class GuildScreen extends StatefulWidget {
  const GuildScreen({
    super.key,
    //title likely to be switched to guild name in future
    required this.title,
    required this.viewModel,
  });

  final String title;
  //this contains the guild_viewmodel data
  final GuildViewmodel viewModel;

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen> {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              //replace with actual navigation logic in the future
              ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Go to guild settings page')),
                        );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: widget.viewModel.guildChats.map((chatName) {
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
                        chatName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onTap: () {
                        // temporary simple navigation
                        context.push('/chat');
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
