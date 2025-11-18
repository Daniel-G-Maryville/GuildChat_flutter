import 'package:go_router/go_router.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/homepage/home_screen.dart';
import 'package:guild_chat/ui/homepage/home_viewmodel.dart';
import 'package:guild_chat/ui/login/login_provider.dart';
import 'package:guild_chat/ui/user/user_screen.dart';
import 'package:guild_chat/ui/user/user_viewmodel.dart';
import 'package:guild_chat/ui/login/login_screen.dart';
import 'package:guild_chat/ui/user/create_user_screen.dart';
import 'package:guild_chat/ui/core/widgets/splash_screen.dart';

final String title = 'Guild Chat';

// final authListenableProvider = Provider.autoDispose<ValueNotifier<void>>((ref) {
//   final notifier = ValueNotifier<void>(null);
//   ref.listen(authNotifierProvider, (_, _) {
//     notifier.value = null; // Trigger on any auth change
//   });
//   ref.onDispose(notifier.dispose);
//   return notifier;
// });

final routerProvider = Provider<GoRouter>((ref) {
  // final authListenable = ref.watch(authListenableProvider);
  return GoRouter(
    // refreshListenable: authListenable,
    // This redirect logic is to handle first time login
    redirect: (context, state) {
      final authState = ref.watch(authNotifierProvider);
      if (authState.isLoading) return null;
      final isLoggedIn = authState.user != null;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnCreateUser = state.matchedLocation == '/user/create';

      if (!isOnCreateUser && authState.isNewUser) return '/user/create';
      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      // GoRoute(path: '/user', builder: (context, state) => UserScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            HomeScreen(title: title, viewModel: HomeViewmodel()),
      ),
      GoRoute(
        path: '/user',
        builder: (context, state) =>
            UserScreen(title: title, viewModel: UserViewmodel()),
      ),
      GoRoute(
        path: '/user/create',
        builder: (context, state) => CreateUserScreen(),
      ),
    ],
  );
});
