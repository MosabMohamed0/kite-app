part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final bool isGoogleLogin;
  AuthLoading({this.isGoogleLogin = false});
}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSignedOut extends AuthState {}

class AuthPasswordReset extends AuthState {}
