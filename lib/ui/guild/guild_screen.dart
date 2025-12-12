import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';

class GuildScreen extends ConsumerStatefulWidget {
  const GuildScreen({super.key});

  @override
  ConsumerState<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends ConsumerState<GuildScreen> {
  //this creates the top navigation pannel
  @override
  Widget build(BuildContext context) {
    final guildState = ref.watch(guildNotifierProvider);
    final guildName = guildState.data?.guildName;
    // final channels = 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(guildName ?? "Unknown"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/guild/settings/update');
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
                children: viewModel.guildChats.map((chatName) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.forum_rounded, size: 30),
                      ),
                      title: Text(
                        chatName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onTap: () {
                        // navigation to specific chat page by guild and chat name
                        context.push('/chat/${widget.guildName}/$chatName');
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
