// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:depi_app/core/utils/auth_service.dart';
// import 'package:depi_app/features/auth/data/repos/auth_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthService _authService;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   AuthRepositoryImpl(this._authService);

//   @override
//   Future<void> signUp({
//     required String email,
//     required String password,
//     required String fullName,
//   }) async {
//     await _authService.signUp(email, password, fullName);
//   }

//   @override
//   Future<void> signIn({required String email, required String password}) async {
//     await _authService.signIn(email, password);
//   }

//   @override
//   Future<void> signOut() async {
//     await _authService.signOut();
//   }

//   @override
//   Future<void> resetPassword({required String email}) async {
//     await _authService.resetPassword(email);
//   }

//   @override
//   Future<User?> signInWithGoogle(context) async {
//     return await _authService.signInWithGoogle(context);
//   }

//   @override
//   Future<void> updateUserData({
//     required String uid,
//     required String fullName,
//     required String email,
//     required String phone,
//     required List<String> addresses,
//   }) async {
//     if (_authService.currentUser?.email != email) {
//       await _authService.currentUser?.verifyBeforeUpdateEmail(email);
//     }
//     await _authService.currentUser?.updateDisplayName(fullName);

//     await _firestore.collection('users').doc(uid).update({
//       'fullName': fullName,
//       'email': email,
//       'phone': phone,
//       'address': addresses,
//     });
//   }

//   // @override
//   Stream<bool> get authStateChanges =>
//       _authService.currentUser != null
//           ? Stream.value(true)
//           : Stream.value(false);
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/utils/auth_service.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  // ✨ التعديل 1: إزالة = FirebaseFirestore.instance من هنا
  final FirebaseFirestore _firestore; 

  // ✨ التعديل 2: إضافة firestore اختياريًا للـ Constructor
  AuthRepositoryImpl(this._authService, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance; // استخدام المثيل المُمرر أو الافتراضي

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _authService.signUp(email, password, fullName);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _authService.signIn(email, password);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _authService.resetPassword(email);
  }

  @override
  Future<User?> signInWithGoogle(context) async {
    return await _authService.signInWithGoogle(context);
  }

  @override
  Future<void> updateUserData({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
    required List<String> addresses,
  }) async {
    if (_authService.currentUser?.email != email) {
      await _authService.currentUser?.verifyBeforeUpdateEmail(email);
    }
    await _authService.currentUser?.updateDisplayName(fullName);

    await _firestore.collection('users').doc(uid).update({
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': addresses,
    });
  }
}