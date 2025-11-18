import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/user/user_provider.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserState();
}

class _CreateUserState extends ConsumerState<CreateUserScreen> {
  final _title = 'Create User Profile';
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {}); // Triggers rebuild as user types
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authEmailProvider).value;
    final userState = ref.watch(userNotifierProvider);
    _emailController.text = email!;

    if (userState.data != null) {
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        if (mounted) {
          context.go('/home');
        }
      });
    }

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
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 20),
            if (userState.isLoading) const CircularProgressIndicator(),
            if (userState.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  userState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: _usernameController.text == ''
                  ? null
                  : () => 
                    ref
                    .read(userNotifierProvider.notifier)
                    .create(
                      email: email, // use a guarnteed value
                      username: _usernameController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                    ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
