class AuthState {
  final String? email;
  final String? error;
  final bool isLoading;
  final bool isLoggedIn;
  final bool isNewUser;

  const AuthState({
    this.email = '',
    this.error,
    this.isLoading = false,
    this.isLoggedIn = false,
    this.isNewUser = false,
  });

  AuthState copyWith({
    String? email,
    bool? isLoading,
    bool? isNewUser,
    bool? isLoggedIn,
    String? error,
  }) {
    return AuthState(
      email: email,
      isLoading: isLoading ?? this.isLoading,
      isNewUser: isNewUser ?? this.isNewUser,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error ?? this.error,
    );
  }
}
