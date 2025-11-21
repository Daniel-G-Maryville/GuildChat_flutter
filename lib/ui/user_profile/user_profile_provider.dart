import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/data/user_repository.dart'; // Your repo
import 'package:guild_chat/models/data_state.dart';
import 'package:guild_chat/models/user.dart'; // Your User model
import 'package:guild_chat/ui/login/login_provider.dart'; // For authNotifierProvider

final userByEmailProvider = FutureProvider.autoDispose<UserProfile?>((
  ref,
) async {
  final email = ref.watch(authEmailProvider).value;

  return await UserRepository.getUserByEmail(email!); // Await here
});

final authEmailProvider = FutureProvider.autoDispose<String?>((ref) async {
  return ref.watch(authNotifierProvider).email;
});

class UserProfileNotifier extends Notifier<DataState<UserProfile>> {
  @override
  DataState<UserProfile> build() {
    return DataState<UserProfile>.initalize();
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
          state = DataState.success(userProfile);
          ref.read(authNotifierProvider.notifier).userCreated();
        }
      }
    } catch (e) {
      state = DataState<UserProfile>.error(e.toString());
    }
  }

  Future<void> update({
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
        await UserRepository.update(
          email: email,
          firstName: firstName,
          lastName: lastName,
          username: username,
        );
      }
    } catch (e) {
      state = DataState<UserProfile>.error(e.toString());
    }
  }

  void clearError() => state = DataState.initalize();
}

final userProfileNotifierProvider =
    NotifierProvider<UserProfileNotifier, DataState<UserProfile>>(
      () => UserProfileNotifier(),
    );
