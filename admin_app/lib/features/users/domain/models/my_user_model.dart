import 'package:equatable/equatable.dart';

class ProductSelected extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyOrder extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyUser extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? photoUrl;
  final List<String> address;
  final String? phone;

  const MyUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.address = const [],
    this.phone,
  });

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] as String?,
      address: map['address'] != null ? List<String>.from(map['address']) : [],
      phone: map['phone'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, photoUrl, address, phone];
}
