import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'review_model.dart';

enum ProductAttributeType { none, color, size, both }

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  final List<Review> comments;
  final double rate;
  final int reviews;
  final String brand;
  final String category;
  final String description;
  final List<String> instruction;
  final ProductAttributeType productAttributeType;
  final Map<String, dynamic> stock;
  final Timestamp date;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.comments,
    required this.rate,
    required this.reviews,
    required this.brand,
    required this.category,
    required this.description,
    required this.instruction,
    required this.productAttributeType,
    required this.stock,
    required this.date,
  });

  int get totalQuantity {
    if (stock.isEmpty) return 0;

    if (productAttributeType == ProductAttributeType.none) {
      return (stock['total'] as int?) ?? 0;
    }

    if (productAttributeType == ProductAttributeType.size ||
        productAttributeType == ProductAttributeType.color) {
      return stock.values.fold(0, (sum, item) => sum + (item as int));
    }

    if (productAttributeType == ProductAttributeType.both) {
      return stock.values.fold(0, (sum, colorMap) {
        final nestedMap = colorMap as Map<String, dynamic>;
        return sum + nestedMap.values.fold(0, (s, val) => s + (val as int));
      });
    }

    return 0;
  }

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
      productAttributeType: _stringToAttributeType(map['productAttributeType']),
      stock: Map<String, dynamic>.from(map['stock'] ?? {}),
      date: map['date'] ?? Timestamp.now(),
    );
  }

  static ProductAttributeType _stringToAttributeType(String? value) {
    switch (value) {
      case 'size':
        return ProductAttributeType.size;
      case 'color':
        return ProductAttributeType.color;
      case 'both':
        return ProductAttributeType.both;
      case 'none':
      default:
        return ProductAttributeType.none;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    photoUrl,
    comments,
    rate,
    reviews,
    brand,
    category,
    description,
    instruction,
    productAttributeType,
    stock,
    date,
  ];

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? photoUrl,
    String? brand,
    String? category,
    String? description,
    List<String>? instruction,
    ProductAttributeType? productAttributeType,
    Map<String, dynamic>? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      description: description ?? this.description,
      instruction: instruction ?? this.instruction,
      productAttributeType: productAttributeType ?? this.productAttributeType,
      stock: stock ?? this.stock,
      comments: comments,
      rate: rate,
      reviews: reviews,
      date: date,
    );
  }
}
