// auth_cubit_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:depi_app/core/errors/failures.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_cubit_test.mocks.dart'; // This file will be generated after running build_runner

// Generate mocks for classes that AuthCubit depends on
@GenerateMocks([AuthRepository, User])
void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  // Set up environment before each test
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(mockAuthRepository);
    mockUser = MockUser();
  });

  // Clean up after each test
  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Tests', () {
    const String tEmail = 'test@example.com';
    const String tPassword = 'password123';
    const String tFullName = 'Test User';
    const String tUid = 'uid-123';
    const String tPhone = '1234567890';
    const List<String> tAddresses = ['Address 1', 'Address 2'];

    // Example of a Firebase exception
    final FirebaseAuthException tFirebaseAuthException = FirebaseAuthException(
      code: 'invalid-credential',
      message: 'test error message',
    );

    // -------------------------------------------------------------------------
    // Test signIn method
    // -------------------------------------------------------------------------

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when signIn is successful',
      build: () {
        when(mockAuthRepository.signIn(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.signIn(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
      verify: (_) {
        verify(mockAuthRepository.signIn(
          email: tEmail,
          password: tPassword,
        )).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when signIn fails with FirebaseAuthException',
      build: () {
        when(mockAuthRepository.signIn(
          email: tEmail,
          password: tPassword,
        )).thenThrow(tFirebaseAuthException);
        return authCubit;
      },
      act: (cubit) => cubit.signIn(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (e) => e.message,
          'message',
          // We rely on ServerFailure to convert the exception into an error message
          ServerFailure.fromFirebaseAuth(tFirebaseAuthException).errmessage,
        ),
      ],
    );

    // -------------------------------------------------------------------------
    // Test signUp method
    // -------------------------------------------------------------------------

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when signUp is successful',
      build: () {
        when(mockAuthRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        )).thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.signUp(tEmail, tPassword, tFullName),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );

    // -------------------------------------------------------------------------
    // Test resetPassword method
    // -------------------------------------------------------------------------

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthPasswordReset] when password reset is successful',
      build: () {
        when(mockAuthRepository.resetPassword(email: tEmail))
            .thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.resetPassword(tEmail),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthPasswordReset>(),
      ],
    );

    // -------------------------------------------------------------------------
    // Test signOut method
    // -------------------------------------------------------------------------

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSignedOut] when signOut is successful',
      build: () {
        when(mockAuthRepository.signOut()).thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSignedOut>(),
      ],
    );

    // -------------------------------------------------------------------------
    // Test signInWithGoogle method
    // -------------------------------------------------------------------------

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading(isGoogleLogin: true), AuthSuccess] when Google sign-in is successful',
      build: () {
        when(mockAuthRepository.signInWithGoogle(any))
            .thenAnswer((_) async => mockUser);
        return authCubit;
      },
      act: (cubit) => cubit.signInWithGoogle(null),
      expect: () => [
        isA<AuthLoading>().having((s) => s.isGoogleLogin, 'isGoogleLogin', true),
        isA<AuthSuccess>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when Google sign-in is cancelled (user is null)',
      build: () {
        when(mockAuthRepository.signInWithGoogle(any))
            .thenAnswer((_) async => null);
        return authCubit;
      },
      act: (cubit) => cubit.signInWithGoogle(null),
      expect: () => [
        isA<AuthLoading>().having((s) => s.isGoogleLogin, 'isGoogleLogin', true),
        isA<AuthError>().having(
          (e) => e.message,
          'message',
          'Google Sign-In cancelled by user',
        ),
      ],
    );

    // -------------------------------------------------------------------------
    // Test updateUserProfile method
    // -------------------------------------------------------------------------

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when updating user profile is successful',
      build: () {
        when(mockAuthRepository.updateUserData(
          uid: tUid,
          fullName: tFullName,
          email: tEmail,
          phone: tPhone,
          addresses: tAddresses,
        )).thenAnswer((_) async => Future.value());
        return authCubit;
      },
      act: (cubit) => cubit.updateUserProfile(
        uid: tUid,
        fullName: tFullName,
        email: tEmail,
        phone: tPhone,
        addresses: tAddresses,
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
      verify: (_) {
        verify(mockAuthRepository.updateUserData(
          uid: tUid,
          fullName: tFullName,
          email: tEmail,
          phone: tPhone,
          addresses: tAddresses,
        )).called(1);
      },
    );
  });
}
