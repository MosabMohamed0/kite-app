import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

enum PaymentMethod { cash, visa }

enum Status { delivered, canceled, shipped, processing, pending }

class MyOrder {
  final String id;
  final String userId;
  final List<ProductSelected> products;
  final double totalPrice;
  final Timestamp date;
  final PaymentMethod paymentMethod;
  final Status status;
  // final List<String> address;
  final String customerName;
  final String customerPhone;
  final String customerAddress;


  MyOrder({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.paymentMethod,
    // required this.address,
    required this.customerAddress,
    required this.customerName,
    required this.customerPhone,
  });

  String get paymentMethodFriendly {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return "Cash on Delivery";
      case PaymentMethod.visa:
        return "Visa / Credit Card";
    }
  }


  factory MyOrder.fromMap(Map<String, dynamic> map, {required String id}) {
    return MyOrder(
      id: id,
      userId: map['userId'],
      products: map['products'] != null
          ? List<ProductSelected>.from(
        map['products'].map((e) => ProductSelected.fromMap(e)),
      )
          : [],
      totalPrice: (map['totalPrice'] as num).toDouble(),
      date: map['date'] ?? Timestamp.now(),
      status: Status.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => Status.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      // address: map['address'] != null
      //     ? List<String>.from(map['address'])
      //     : [],
      customerAddress: map['customerAddress'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'date': date,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      // 'address': address,
      'customerAddress':customerAddress,
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
  }

}
