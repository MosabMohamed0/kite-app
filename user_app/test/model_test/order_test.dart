import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/order.dart';
import 'package:depi_app/core/models/selectedProduct.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyOrder Model Tests', () {
    
    // Helper function to create a sample ProductSelected
    ProductSelected createSampleProductSelected() {
      return ProductSelected(
        id: 'p1',
        productId: 'prod123', 
        name: 'iPhone 14',
        price: 999.99,
        brand: 'Apple',
        category: "Electronics",
        photoURL: "https://example.com/iphone.jpg",
        productDetails: {},
      );
    }

    test('should create MyOrder from map with products', () {
      final map = {
        'userId': 'u123',
        'products': [createSampleProductSelected().toMap()],
        'totalPrice': 999.99,
        'date': Timestamp.now(),
        'status': 'delivered',
        'paymentMethod': 'visa',
        'customerAddress': '123 Street',
        'customerName': 'John Doe',
        'customerPhone': '0123456789',
      };

      final order = MyOrder.fromMap(map, id: 'o1');

      expect(order.id, 'o1');
      expect(order.userId, 'u123');
      expect(order.products.length, 1);
      expect(order.totalPrice, 999.99);
      expect(order.status, Status.delivered);
      expect(order.paymentMethod, PaymentMethod.visa);
      expect(order.customerAddress, '123 Street');
      expect(order.customerName, 'John Doe');
      expect(order.customerPhone, '0123456789');
    });

    test('should convert MyOrder to map', () {
      final order = MyOrder(
        id: 'o1',
        userId: 'u123',
        products: [createSampleProductSelected()],
        totalPrice: 999.99,
        date: Timestamp.now(),
        status: Status.shipped,
        paymentMethod: PaymentMethod.cash,
        customerAddress: '123 Street',
        customerName: 'John Doe',
        customerPhone: '0123456789',
      );

      final map = order.toMap();

      expect(map['id'], 'o1');
      expect(map['userId'], 'u123');
      expect(map['products'].length, 1);
      expect(map['totalPrice'], 999.99);
      expect(map['status'], 'shipped');
      expect(map['paymentMethod'], 'cash');
      expect(map['customerAddress'], '123 Street');
      expect(map['customerName'], 'John Doe');
      expect(map['customerPhone'], '0123456789');
    });

    test('should handle missing status and paymentMethod in map', () {
      final map = {
        'userId': 'u123',
        'products': [],
        'totalPrice': 0.0,
        'date': Timestamp.now(),
        'customerAddress': '123 Street',
        'customerName': 'John Doe',
        'customerPhone': '0123456789',
      };

      final order = MyOrder.fromMap(map, id: 'o2');

      expect(order.status, Status.pending);
      expect(order.paymentMethod, PaymentMethod.cash);
    });

    test('should return correct paymentMethodFriendly string', () {
      final cashOrder = MyOrder(
        id: 'o1',
        userId: 'u1',
        products: [],
        totalPrice: 0,
        date: Timestamp.now(),
        status: Status.pending,
        paymentMethod: PaymentMethod.cash,
        customerAddress: '',
        customerName: '',
        customerPhone: '',
      );

      final visaOrder = MyOrder(
        id: 'o2',
        userId: 'u2',
        products: [],
        totalPrice: 0,
        date: Timestamp.now(),
        status: Status.pending,
        paymentMethod: PaymentMethod.visa,
        customerAddress: '',
        customerName: '',
        customerPhone: '',
      );

      expect(cashOrder.paymentMethodFriendly, 'Cash on Delivery');
      expect(visaOrder.paymentMethodFriendly, 'Visa / Credit Card');
    });
  });
}
