import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; // Provides debugPrint
import 'package:guild_chat/data/user_repository.dart'; // Your repo
import 'package:guild_chat/models/data_state.dart';
import 'package:guild_chat/models/user_profile.dart'; // Your User model
import 'package:guild_chat/ui/login/login_provider.dart'; // For authNotifierProvider

final userByEmailProvider = FutureProvider.autoDispose<UserProfile?>((
  ref,
) async {
  final email = ref.watch(authServiceProvider).email;
  debugPrint("Email: $email");

  if (email == null) return null;

  return await UserRepository.getUserByEmail(email); // Await here
});

class UserProfileNotifier extends Notifier<DataState<UserProfile>> {
  @override
  DataState<UserProfile> build() {
    final asyncUser = ref.watch(userByEmailProvider);
    debugPrint("User data $asyncUser");
    return asyncUser.when(
      data: (user) =>
          user != null ? DataState.success(user) : DataState.initalize(),
      loading: () => DataState.loading(),
      error: (err, stack) => DataState.error(err.toString()),
    );
  }

  Future<void> create({
    String email = '',
    String firstName = '',
    String lastName = '',
    String username = '',
  }) async {
    state = DataState<UserProfile>.loading();

    try {
      UserProfile? userProfile = ref.watch(userByEmailProvider).value;
      if (userProfile != null) {
        state = DataState.error("User already exists");
      } else {
        userProfile = await UserRepository.create(
          email: email,
          firstName: firstName,
          lastName: lastName,
          username: username,
        );
        if (userProfile != null) {
          state = DataState<UserProfile>.success(userProfile);
          ref.read(authNotifierProvider.notifier).userCreated();
        }
      }
    } catch (e) {
      state = DataState<UserProfile>.error(e.toString());
    }
  }

  Future<void> update({
    String firstName = '',
    String lastName = '',
    String username = '',
  }) async {
    String? email = state.data?.email;
    state = DataState<UserProfile>.loading(data: state.data);
    debugPrint(
      "Updating with\nemail: $email, firstName: $firstName, lastName: $lastName, username: $username ",
    );

    try {
      await UserRepository.update(
        email: email!,
        firstName: firstName,
        lastName: lastName,
        username: username,
      );
      // Refetch the user
      final userProfile = await UserRepository.getUserByEmail(email);
      state = DataState.success(userProfile!);
    } catch (e) {
      state = DataState<UserProfile>.error(e.toString(), data: state.data);
    }
  }

  void clearError() => state = DataState.initalize();
}

final userProfileNotifierProvider =
    NotifierProvider<UserProfileNotifier, DataState<UserProfile>>(
      () => UserProfileNotifier(),
    );
