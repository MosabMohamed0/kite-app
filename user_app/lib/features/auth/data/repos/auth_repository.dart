import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> resetPassword({required String email});
  Future<void> signOut();
  Future<User?> signInWithGoogle(context);

  Future<void> updateUserData({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
    required List<String> addresses,
  });
}
