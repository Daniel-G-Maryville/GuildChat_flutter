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
}

// ViewModel (now using Notifier)
class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _service = ref.watch(authServiceProvider);

  @override
  AuthState build() {
    return const AuthState();  // Initial state here
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cred = await _service.signIn(email, password);
      state = state.copyWith(user: cred.user, isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'An unexpected error occurred', isLoading: false);
    }
  }

  Future<void> create(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cred = await _service.create(email, password);
      state = state.copyWith(user: cred.user, isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'An unexpected error occurred', isLoading: false);
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());