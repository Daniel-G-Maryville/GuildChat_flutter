import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateGuildScreen extends StatefulWidget {
  const UpdateGuildScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<UpdateGuildScreen> createState() => _UpdateGuildScreenState();
}

class _UpdateGuildScreenState extends State<UpdateGuildScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          //this button will be later used to delete specific guilds
          //this section may be expanded later to add more guild features and settings
          children: [
            ElevatedButton(
              onPressed: () {
                //replace with actual guild creation logic in the future
              ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted Guild')),
                        );
              },
              child: const Text('Delete Guild'),
            ),
          ]
        ),
      ),
    );
  }
}
