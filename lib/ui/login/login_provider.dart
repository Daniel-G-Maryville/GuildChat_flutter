import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guild_chat/models/auth_state.dart'; // Use package import!

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> create(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> checkSession() async {
    final user = _auth.currentUser;

    debugPrint("Do we ever get here?");
    if (user != null) {
      try {
        await user.getIdToken(true); // Force refresh
      } catch (e) {
        await _auth.signOut();
      }
    }
  }

  User? get currentUser => _auth.currentUser;
  String? get email => _auth.currentUser?.email;
  String? get uid => _auth.currentUser?.uid;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// This is the notifier for our auth_state object.
// It uses the Firesbase Auth service to log in or craete a new account
// This updates the state of our auth_state object for listeners
class AuthStateNotifier extends Notifier<AuthState> {
  late final AuthService _service = ref.watch(authServiceProvider);

  @override
  AuthState build() {
    bool isLoggedIn = _service.isLoggedIn;
    if (isLoggedIn) {
      return AuthState(email: _service.email, isLoggedIn: isLoggedIn);
    }
    return const AuthState();
  }

  void userCreated() {
    state = state.copyWith(isNewUser: false);
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cred = await _service.signIn(email, password);
      state = state.copyWith(
        email: cred.user?.email,
        isLoggedIn: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> create(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.create(email, password);
      state = state.copyWith(
        email: email,
        isLoggedIn: true,
        isLoading: false,
        isNewUser: true,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
final authNotifierProvider = NotifierProvider<AuthStateNotifier, AuthState>(
  () => AuthStateNotifier(),
);
