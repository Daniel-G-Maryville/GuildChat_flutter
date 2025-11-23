import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/user_profile/user_profile_provider.dart';

class UpdateUserProfileScreen extends ConsumerStatefulWidget {
  const UpdateUserProfileScreen({super.key});

  @override
  ConsumerState<UpdateUserProfileScreen> createState() =>
      _UpdateUserProfileState();
}

class _UpdateUserProfileState extends ConsumerState<UpdateUserProfileScreen> {
  final _title = 'User Profile';
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
    final userState = ref.watch(userProfileNotifierProvider);
    _emailController.text = userState.data?.email ?? '';
    _firstNameController.text = userState.data?.firstName ?? '';
    _lastNameController.text = userState.data?.lastName ?? '';
    _usernameController.text = userState.data?.username ?? '';

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
                  : () {
                      ref
                          .read(userProfileNotifierProvider.notifier)
                          .update(
                            username: _usernameController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                          );
                      context.pop();
                    },
              child: const Text('Save'),
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
