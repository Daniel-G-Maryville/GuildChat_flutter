import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';

class GuildScreen extends ConsumerStatefulWidget {
  final String id;

  const GuildScreen({super.key, required this.id});

  @override
  ConsumerState<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends ConsumerState<GuildScreen> {
  @override
  Widget build(BuildContext context) {
    final guildName = widget.id;
    final channels = ref.watch(channelProvider(guildName));
    debugPrint("In the guild/:id screen");

    debugPrint(channels.toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(guildName),
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
      body: channels.when(
        data: (channels) {
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
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
                    channel,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  onTap: () {
                    // Navigate to specific chat page using guildName and channel
                    context.push('/chat/$guildName/$channel');
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading channels: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(channelProvider(guildName)), // Refresh on error
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
