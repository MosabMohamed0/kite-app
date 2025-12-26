import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'product_selected_model.dart';

enum PaymentMethod { cash, visa }

enum OrderStatus { delivered, canceled, shipped, processing, pending }

class MyOrder extends Equatable {
  final String id;
  final String userId;
  final List<ProductSelected> products;
  final double totalPrice;
  final Timestamp date;
  final PaymentMethod paymentMethod;
  final OrderStatus status;

  final String customerName;
  final String customerPhone;
  final String customerAddress;

  const MyOrder({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
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

  factory MyOrder.fromMap(Map<String, dynamic> map) {
    return MyOrder(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      products:
          (map['products'] as List?)
              ?.map((e) => ProductSelected.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPrice: _parsePrice(map['totalPrice']),
      date: map['date'] as Timestamp? ?? Timestamp.now(),
      status: _stringToStatus(map['status']),
      paymentMethod: _stringToPaymentMethod(map['paymentMethod']),
      customerName: map['customerName'] as String,
      customerPhone: map['customerPhone'] as String,
      customerAddress: map['customerAddress'] as String,
    );
  }

  static OrderStatus _stringToStatus(String? value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.processing,
    );
  }

  static PaymentMethod _stringToPaymentMethod(String? value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentMethod.cash,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      products,
      totalPrice,
      date,
      status,
      paymentMethod,
      customerName,
      customerPhone,
      customerAddress,
    ];
  }
}
