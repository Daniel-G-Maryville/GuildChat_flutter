import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';

class CreateGuildScreen extends ConsumerStatefulWidget {
  const CreateGuildScreen({super.key});

  @override
  ConsumerState<CreateGuildScreen> createState() => _CreateGuildScreenState();
}

class _CreateGuildScreenState extends ConsumerState<CreateGuildScreen> {
  final _title = "Create Guild";
  final _guildNameController = TextEditingController();
  final _guildDescriptionController = TextEditingController();

  //top navigation pannel construction
  @override
  Widget build(BuildContext context) {
    final guild = ref.watch()
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(_title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //this holds the textboxes and button to later control the creation of a guild
          children: [
            TextField(
              controller: _guildNameController,
              decoration: const InputDecoration(labelText: 'Guild Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _guildDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                //replace with actual guild creation logic in the future
              ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Create ${_guildNameController.text} guild')),
                        );
              },
              child: const Text('Create Guild'),
            ),
          ]
        ),
      ),
    );
  }
}
