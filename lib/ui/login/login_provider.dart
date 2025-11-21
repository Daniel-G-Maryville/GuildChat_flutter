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

  User? get currentUser => _auth.currentUser;
  String? get email => _auth.currentUser?.email;
  String? get uid => _auth.currentUser?.uid;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// ViewModel (now using Notifier)
class AuthNotifier extends Notifier<AuthState> {
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

// Providers
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.authStateChanges
      .map((user) {
        if (user == null) {
          return AuthState();
        } else {
          return AuthState(email: user.email);
        }
      })
      .handleError((error) {
        return AuthState(error: error.toString());
      });
});
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
