import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FindGuildScreen extends StatefulWidget {
  const FindGuildScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<FindGuildScreen> createState() => _FindGuildScreenState();
}

class _FindGuildScreenState extends State<FindGuildScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _guildNameController = TextEditingController();

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
              onPressed: () {
                //replace with actual guild finding logic in the future
              ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Find ${_guildNameController.text} guild')),
                        );
              },
              child: const Text('Find Guild'),
            ),
          ]
        ),
      ),
    );
  }
}
