import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/data/user_repository.dart'; // Your repo
import 'package:guild_chat/models/data_state.dart';
import 'package:guild_chat/models/user.dart'; // Your User model
import 'package:guild_chat/ui/login/login_provider.dart'; // For authNotifierProvider

final userByEmailProvider = FutureProvider.autoDispose<User?>((ref) async {
  final email = ref.watch(authEmailProvider).value;

  return await UserRepository.getUserByEmail(email!); // Await here
});

final authEmailProvider = FutureProvider.autoDispose<String?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final email = authState.user?.email;

  return email;
});

class UserNotifier extends Notifier<DataState<User>> {
  @override
  DataState<User> build() {
    return DataState<User>.initalize();
  }

  Future<void> create({
    String email = '',
    String firstName = '',
    String lastName = '',
    String username = '',
  }) async {
    state = DataState<User>.loading();

    try {
      User? user = ref.watch(userByEmailProvider).value;
      if (user != null) {
        state = DataState.error("User already exists");
      } else {
        user = await UserRepository.create(
          email: email,
          firstName: firstName,
          lastName: lastName,
          username: username,
        );
        if (user != null) {
          state = DataState.success(user);
        }
      }
    } catch (e) {
      state = DataState<User>.error(e.toString());
    }
  }

  void clearError() => state = DataState.initalize();
}

final userNotifierProvider = NotifierProvider<UserNotifier, DataState<User>>(
  () => UserNotifier(),
);
