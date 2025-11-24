import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/homepage/home_screen.dart';
import 'package:guild_chat/ui/homepage/home_viewmodel.dart';
import 'package:guild_chat/ui/login/login_provider.dart';
import 'package:guild_chat/ui/login/login_screen.dart';
import 'package:guild_chat/ui/user_profile/create_user_profile_screen.dart';
import 'package:guild_chat/ui/core/widgets/splash_screen.dart';
import 'package:guild_chat/ui/user_profile/update_user_profile_screen.dart';
import 'package:guild_chat/ui/guild/guild_viewmodel.dart';
import 'package:guild_chat/ui/guild/guild_screen.dart';
import 'package:guild_chat/ui/chat/chat_screen.dart';
import 'package:guild_chat/ui/chat/chat_viewmodel.dart';

final String title = 'Guild Chat';

final authListenableProvider = Provider.autoDispose<ValueNotifier<void>>((ref) {
  final notifier = ValueNotifier<void>(null);
  ref.listen(authNotifierProvider, (_, _) {
    notifier.value = null; // Trigger on any auth change
  });
  ref.onDispose(notifier.dispose);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = ref.watch(authListenableProvider);
  return GoRouter(
    refreshListenable: authListenable,
    // This redirect logic is to handle first time login
    redirect: (context, state) {
      final authState = ref.watch(authNotifierProvider);
      if (authState.isLoading) return null;
      final isLoggedIn = authState.isLoggedIn;
      final isNewUser = authState.isNewUser;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnCreateUser = state.matchedLocation == '/user_profile/create';
      final isOnSplash = state.matchedLocation == '/splash';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isNewUser && !isOnCreateUser) return '/user_profile/create';
      if (isLoggedIn && isOnLogin) return '/home';
      if (isOnSplash && !isNewUser) return '/home';

      return null;
    },
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            HomeScreen(title: title, viewModel: HomeViewmodel()),
      ),
      GoRoute(
        path: '/user_profile/create',
        builder: (context, state) => CreateUserProfileScreen(),
      ),
      GoRoute(
        path: '/user_profile/:id',
        builder: (context, state) => UpdateUserProfileScreen(),
      ),
      GoRoute(
        path: '/guild',
        builder: (context, state) => GuildScreen(title: title, viewModel: GuildViewmodel()), 
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => ChatScreen(title: title, viewModel: ChatViewmodel()), 
      ),
    ],
  );
});
