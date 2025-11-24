import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateGuildScreen extends StatefulWidget {
  const CreateGuildScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<CreateGuildScreen> createState() => _CreateGuildScreenState();
}

class _CreateGuildScreenState extends State<CreateGuildScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _guildNameController = TextEditingController();
  final _guildDescriptionController = TextEditingController();

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
          //this holds the textboxes and button to later control the creation of a guild
          children: [
            TextField(
              controller: _guildNameController,
              decoration: const InputDecoration(labelText: 'Guild Name'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _guildDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              obscureText: true,
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
