import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/review.dart';

enum ProductAttributeType { color, size, both, none }

class Product {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  List<Review> comments;
  double rate;
  final int reviews;
  final String brand;
  final String category;
  final String description;
  final List<String> instruction;
  final ProductAttributeType productAttributeType;
  final dynamic stock;
  final Timestamp date;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.comments,
    required this.reviews,
    required this.brand,
    required this.category,
    required this.description,
    required this.instruction,
    required this.productAttributeType,
    required this.stock,
    required this.date,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'photoUrl': photoUrl,
      'comments': comments.map((x) => x.toMap()).toList(),
      'rate': rate,
      'reviews': reviews,
      'brand': brand,
      'category': category,
      'description': description,
      'instruction': instruction,
      'productAttributeType': productAttributeType.name,
      'stock': stock,
      'date': date,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      photoUrl: map['photoUrl'] ?? '',
      comments:
          (map['comments'] as List<dynamic>?)
              ?.map((x) => Review.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      rate: (map['rate'] ?? 0).toDouble(),
      reviews: map['reviews'] ?? 0,
      brand: map['brand'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      instruction: List<String>.from(map['instruction'] ?? []),
      productAttributeType: stringToAttributeType(map['productAttributeType']),
      stock: map['stock'],
      date: map['date'] ?? Timestamp.now(),
    );
  }

  static ProductAttributeType stringToAttributeType(String? value) {
    switch (value) {
      case 'size':
        return ProductAttributeType.size;
      case 'both':
        return ProductAttributeType.both;
      case 'color':
        return ProductAttributeType.color;
      default:
        return ProductAttributeType.none;
    }
  }
}
