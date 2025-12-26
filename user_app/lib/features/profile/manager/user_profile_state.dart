part of 'user_profile_cubit.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final String name;
  final String email;
  final DateTime createdAt;
  final List<Map>? cart;
  final List<String>? favorite;
  final String? photoUrl;

  UserProfileLoaded({
    required this.name,
    required this.email,
    required this.createdAt,
     this.cart,
    this.favorite,
    this.photoUrl,
  });
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}
