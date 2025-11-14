import 'package:go_router/go_router.dart';
import 'ui/homepage/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    // GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    // GoRoute(path: '/user', builder: (context, state) => UserScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(title: 'Guild Chat'),
    ),
  ],
  // Optional: Redirect for auth
  redirect: (context, state) {
    // e.g., if not logged in and not on /login, redirect to '/login'
    return null;
  },
);
