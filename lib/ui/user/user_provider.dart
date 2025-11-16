import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/data/user_repository.dart'; // Your repo
import 'package:guild_chat/models/user.dart'; // Your User model
import 'package:guild_chat/ui/login/login_provider.dart'; // For authNotifierProvider

final userByEmailProvider = FutureProvider.autoDispose<User?>((ref) async {
  final email = ref.watch(authEmailProvider).value;

  return await UserRepository.getUserByEmail(email as String); // Await here
});

final authEmailProvider = FutureProvider.autoDispose<String?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final email = authState.user?.email;

  return email;
});

