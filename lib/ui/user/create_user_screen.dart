import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/user/user_provider.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserState();
}

class _CreateUserState extends ConsumerState<CreateUserScreen> {
  final _title = 'Create User Profile';
  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authEmailProvider).value;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController(text: email as String);
    final usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            ElevatedButton(
              onPressed: usernameController.text == ''
                  ? null // Set error
                  : null, // call create
                  // () => ref
                  //       .create(
                  //         _emailController.text,
                  //         _usernameController.text,
                  //         _firstNameController.text,
                  //         _lastNameController.text,
                  //       ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
