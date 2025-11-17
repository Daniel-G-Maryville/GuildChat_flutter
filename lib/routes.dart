import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/homepage/home_screen.dart';
import 'package:guild_chat/ui/homepage/home_viewmodel.dart';
import 'package:guild_chat/ui/login/login_provider.dart';
import 'package:guild_chat/ui/user/user_screen.dart';
import 'package:guild_chat/ui/user/user_viewmodel.dart';
import 'package:guild_chat/ui/login/login_screen.dart';
import 'package:guild_chat/ui/user/create_user_screen.dart';

final String title = 'Guild Chat';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      final authState = ref.watch(authNotifierProvider);
      if (authState.isLoading) return null;
      final isLoggedIn = authState.user != null;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnCreateUser = state.matchedLocation == '/user/create';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && authState.isNewUser && !isOnCreateUser) {
        return '/user/create';
      }
      if (isLoggedIn && isOnLogin) return '/home';
      return null;
    },
    initialLocation: '/home',
    routes: [
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
