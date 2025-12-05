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

  @override
  void dispose() {
    _guildNameController.dispose();
    super.dispose();
  }

  //top navigation pannel construction
  @override
  Widget build(BuildContext context) {

    //gets the user email from user data
    final userData = ref.watch(userProfileProvider);
    final userEmail = userData.userEmail;
    
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _guildNameController,
                  decoration: const InputDecoration(
                    labelText: 'Guild Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // make button wider
                  ),
                  onPressed:
                    () {
                          //prevent guild creation without name
                          if (_guildNameController.text.isEmpty) {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter a guild name.')),
                            );
                            return;
                          }
                          //create guild based on name and user email
                          ref.read(guildViewModelProvider.notifier).create(
                                name: _guildNameController.text,
                                owner: userEmail,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Guild Created.')),
                            );
                        }, child: const Text('Create Guild'),
                ),
              ]),        
        ),
      )
    );
  }
}
