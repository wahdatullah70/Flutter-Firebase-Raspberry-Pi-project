import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<({User? user, String? error})> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return (user: result.user, error: null);
    } on FirebaseAuthException catch (e) {
      return (user: null, error: e.message ?? e.code);
    } catch (e) {
      return (user: null, error: e.toString());
    }
  }

  // Sign in with email and password
  Future<({User? user, String? error})> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return (user: result.user, error: null);
    } on FirebaseAuthException catch (e) {
      return (user: null, error: e.message ?? e.code);
    } catch (e) {
      return (user: null, error: e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
