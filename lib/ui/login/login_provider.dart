import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guild_chat/models/auth_state.dart';  // Use package import!


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> create(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// ViewModel (now using Notifier)
class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _service = ref.watch(authServiceProvider);

  @override
  AuthState build() {
    return const AuthState();  // Initial state here
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.signIn(email, password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> create(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cred = await _service.create(email, password);
      state = state.copyWith(isLoading: false, user: cred.user, isNewUser: true);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  void clearError() => state = state.copyWith(error: null);
}

// Providers
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider); // Assume you have a provider for AuthService

  return authService.authStateChanges.map((user) {
    if (user == null) {
      return AuthState();
    } else {
      return AuthState(user: user);
    }
  }).handleError((error) {
    return AuthState(error: error.toString());
  });
});
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());