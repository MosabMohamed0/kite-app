import 'dart:convert';
import 'package:equatable/equatable.dart';

class ProductSelected extends Equatable {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String photoURL;
  final String brand;
  final String category;
  final Map<String, dynamic> productDetails;

  const ProductSelected({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.photoURL,
    required this.brand,
    required this.category,
    required this.productDetails,
  });

  static double _parsePrice(dynamic price) {
    if (price is num) {
      return price.toDouble();
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'photoURL': photoURL,
      'brand': brand,
      'category': category,
      'productDetails': productDetails,
    };
  }

  factory ProductSelected.fromMap(Map<String, dynamic> map) {
    return ProductSelected(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: _parsePrice(map['price']),
      photoURL: map['photoURL'] ?? '',
      brand: map['brand'] ?? '',
      category: map['category'] ?? '',
      productDetails: Map<String, dynamic>.from((map['productDetails'] ?? {})),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductSelected.fromJson(String source) =>
      ProductSelected.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    price,
    photoURL,
    brand,
    category,
    productDetails,
  ];
}
