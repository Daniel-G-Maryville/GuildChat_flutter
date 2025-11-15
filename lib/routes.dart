import 'package:go_router/go_router.dart';
import 'package:guild_chat/ui/homepage/home_screen.dart';
import 'package:guild_chat/ui/homepage/home_viewmodel.dart';
import 'package:guild_chat/ui/user/user_screen.dart';
import 'package:guild_chat/ui/user/user_viewmodel.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    // GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    // GoRoute(path: '/user', builder: (context, state) => UserScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(title: 'Guild Chat', viewModel: HomeViewmodel()),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) =>
          UserScreen(title: 'Guild Chat', viewModel: UserViewmodel()),
    ),
  ],
  // Optional: Redirect for auth
  redirect: (context, state) {
    // e.g., if not logged in and not on /login, redirect to '/login'
    return null;
  },
);
