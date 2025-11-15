import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guild_chat/models/auth_state.dart';  // Use package import!

// Optional: Abstract service for testing (unchanged)
abstract class AuthService {
  Future<UserCredential> signIn(String email, String password);
  Future<bool> isHandleUnique(String handle);
  Future<void> createProfile(String uid, String handle);
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<bool> isHandleUnique(String handle) async {
    final query = await _firestore
        .collection('users')
        .where('handle', isEqualTo: handle)
        .limit(1)
        .get();
    return query.docs.isEmpty;
  }

  @override
  Future<void> createProfile(String uid, String handle) async {
    await _firestore.collection('users').doc(uid).set({
      'handle': handle,
      'email': _auth.currentUser?.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

// ViewModel (now using Notifier)
class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _service = ref.watch(authServiceProvider);  // Access via ref

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

  Future<void> createHandle(String handle) async {
    if (state.user == null) {
      state = state.copyWith(error: 'Login first');
      return;
    }
    try {
      state = state.copyWith(isLoading: true, error: null);
      if (!await _service.isHandleUnique(handle)) {
        throw Exception('Handle $handle is taken');
      }
      await _service.createProfile(state.user!.uid, handle);
      state = state.copyWith(handle: handle, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => FirebaseAuthService());
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());