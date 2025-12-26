import 'package:bloc/bloc.dart';
import 'package:depi_app/core/errors/failures.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. لازم للتعرف على FirebaseAuthException
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(ServerFailure.fromFirebaseAuth(e).errmessage));
    } catch (e) {
      emit(AuthError(ServerFailure(e.toString()).errmessage));
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(ServerFailure.fromFirebaseAuth(e).errmessage));
    } catch (e) {
      emit(AuthError(ServerFailure(e.toString()).errmessage));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(email: email);
      emit(AuthPasswordReset());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(ServerFailure.fromFirebaseAuth(e).errmessage));
    } catch (e) {
      emit(AuthError(ServerFailure(e.toString()).errmessage));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(ServerFailure.fromFirebaseAuth(e).errmessage));
      } else {
        emit(AuthError(ServerFailure(e.toString()).errmessage));
      }
    }
  }

  Future<void> signInWithGoogle(context) async {
    emit(AuthLoading(isGoogleLogin: true));
    try {
      final user = await _authRepository.signInWithGoogle(context);
      if (user == null) {
        emit(AuthError("Google Sign-In cancelled by user"));
        return;
      }
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(ServerFailure.fromFirebaseAuth(e).errmessage));
    } catch (e) {
      emit(AuthError(ServerFailure(e.toString()).errmessage));
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
    required List<String> addresses,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.updateUserData(
        uid: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        addresses: addresses,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(ServerFailure.fromFirebaseAuth(e).errmessage));
    } catch (e) {
      emit(AuthError(ServerFailure(e.toString()).errmessage));
    }
  }
}
