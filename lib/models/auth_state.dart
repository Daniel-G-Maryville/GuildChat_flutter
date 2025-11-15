import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthState {
  final firebase.User? user;
  final bool isLoading;
  final String? error;
  final String? handle;  // For post-login profile

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.handle,
  });

  AuthState copyWith({
    firebase.User? user,
    bool? isLoading,
    String? error,
    String? handle,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      handle: handle ?? this.handle,
    );
  }
}