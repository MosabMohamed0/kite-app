import 'dart:convert';

class ProductSelected {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String photoURL;
  final String brand;
  final String category;
  final Map<String, dynamic> productDetails;

  ProductSelected({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.photoURL,
    required this.brand,
    required this.category,
    required this.productDetails,
  });

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
      id: map['id'] as String,
      productId: map['productId'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      photoURL: map['photoURL'] as String,
      brand: map['brand'] as String,
      category: map['category'] as String,
      productDetails: Map<String, dynamic>.from(
        (map['productDetails'] as Map<String, dynamic>),
      ),
    );
  }

}
