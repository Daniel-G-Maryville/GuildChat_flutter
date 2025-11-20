import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthState {
  final firebase.User? user;
  final firebase.UserCredential? auth;
  final String? error;
  final bool isLoading;
  final bool isLoggedIn;
  final bool isNewUser;

  const AuthState({
    this.user,
    this.auth,
    this.error,
    this.isLoading = false,
    this.isLoggedIn = false,
    this.isNewUser = false,
  });

  AuthState copyWith({
    firebase.UserCredential? auth,
    firebase.User? user,
    bool? isLoading,
    bool? isNewUser,
    bool? isLoggedIn,
    String? error,
  }) {
    return AuthState(
      auth: auth ?? this.auth,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isNewUser: isNewUser ?? this.isNewUser,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error ?? this.error,
    );
  }
}
