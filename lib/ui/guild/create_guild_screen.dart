import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';
import 'package:guild_chat/ui/login/login_provider.dart';

// For the converion to flutter we create a ConsumerStatefulWidget
// We then get rid of most of the state management items in here
// We will also have to change our State to a ConsumerState
class CreateGuildScreen extends ConsumerStatefulWidget {
  const CreateGuildScreen({super.key});

  @override
  ConsumerState<CreateGuildScreen> createState() => _CreateGuildScreenState();
}

// This is our state, notice how it "wraps" our CreateGuildScree.
// This makes sense because the state needs to be at a level above
// the actual display. State can then be passed down to the view.
// Similarly, we need to provide a callback for the view to send data
// back to the state. Riverpod achieves that by supplying the callback
// ref.read() function. From there we can callback to the Notifier, in
// our case we are going to call the create method
class _CreateGuildScreenState extends ConsumerState<CreateGuildScreen> {
  final _title =
      "Create Guild"; // Here we just moved this to here so we aren't having to set that elsewhere
  final _guildNameController = TextEditingController();
  final _guildDescriptionController = TextEditingController();

  @override
  void dispose() {
    _guildNameController.dispose();
    super.dispose();
  }

  // here we need to add a listener to the guild name controller. This is required
  // because we don't want someone to be able to click save with no name written.
  // We therefore need to listen to the state of the controller. That way we can
  // properly activate the submit button when the user has typed something
  @override
  void initState() {
    super.initState();
    _guildNameController.addListener(() {
      setState(() {}); // Triggers rebuild as user types
    });
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
        title: Text(_title), // Use the fial title from above
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
              onPressed: _guildNameController.text == ''
                  ? null
                  : () => ref
                        .read(guildNotifierProvider.notifier)
                        .create(
                          name: _guildNameController.text,
                          // Here we force the email issue. We assume we are logged in
                          // This is likely a bad solution that will cause problems
                          // in the future. Hopefully that future is after this class
                          owner: ref.watch(authServiceProvider).email!,
                        ),
              child: const Text('Create Guild'),
            ),
          ],
        ),
      )
    );
  }
}
