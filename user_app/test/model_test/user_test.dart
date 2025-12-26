import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';
import 'package:depi_app/core/models/user.dart';

void main() {
  group('MyUser Model Tests', () {
    
    // Helper function to create a sample ProductSelected
    ProductSelected createSampleProductSelected() {
      return ProductSelected(
        id: 'p1',
        productId: 'prod123',
        name: 'iPhone 14',
        price: 999.99,
        brand: 'Apple',
        category: 'Electronics',
        photoURL: 'https://example.com/iphone.jpg',
        productDetails: {'color': 'black', 'storage': '128GB'},
      );
    }

    // Helper function to create a sample user
    MyUser createSampleUser() {
      return MyUser(
        id: 'u1',
        fullName: 'John Doe',
        email: 'john@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        address: ['123 Street', '456 Avenue'],
        favorite: ['p1', 'p2'],
        cart: [createSampleProductSelected()],
        date: Timestamp.now(),
        ordersId: ['o1', 'o2'],
      );
    }

    test('should create MyUser object correctly', () {
      final user = createSampleUser();

      expect(user.id, 'u1');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.address.length, 2);
      expect(user.favorite.length, 2);
      expect(user.cart.length, 1);
      expect(user.ordersId.length, 2);
      expect(user.date, isA<Timestamp>());
    });

    test('should convert MyUser to Map correctly', () {
      final user = createSampleUser();
      final map = user.toMap();

      expect(map['id'], 'u1');
      expect(map['name'], 'John Doe');
      expect(map['email'], 'john@example.com');
      expect(map['photoUrl'], 'https://example.com/photo.jpg');
      expect(map['address'], ['123 Street', '456 Avenue']);
      expect(map['favorite'], ['p1', 'p2']);
      expect(map['cart'].length, 1);
      expect(map['ordersId'], ['o1', 'o2']);
      expect(map['date'], isA<Timestamp>());
    });

    test('should create MyUser from Map correctly', () {
      final timestamp = Timestamp.now();
      final map = {
        'id': 'u1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'photoUrl': 'https://example.com/photo.jpg',
        'address': ['123 Street', '456 Avenue'],
        'favorite': ['p1', 'p2'],
        'cart': [createSampleProductSelected().toMap()],
        'date': timestamp,
        'ordersId': ['o1', 'o2'],
      };

      final user = MyUser.fromMap(map);

      expect(user.id, 'u1');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.address, ['123 Street', '456 Avenue']);
      expect(user.favorite, ['p1', 'p2']);
      expect(user.cart.length, 1);
      expect(user.cart.first.name, 'iPhone 14');
      expect(user.ordersId, ['o1', 'o2']);
      expect(user.date, timestamp);
    });

    test('should handle missing or null fields in map', () {
      final map = <String, dynamic>{
        'id': 'u2',
        'name': 'Jane Doe',
        'email': 'jane@example.com',
      };

      final user = MyUser.fromMap(map);

      expect(user.id, 'u2');
      expect(user.fullName, 'Jane Doe');
      expect(user.email, 'jane@example.com');
      expect(user.photoUrl, null);
      expect(user.address, []);
      expect(user.favorite, []);
      expect(user.cart, []);
      expect(user.ordersId, []);
      expect(user.date, isA<Timestamp>());
    });

    test('toMap and fromMap should be consistent', () {
      final user = createSampleUser();
      final map = user.toMap();
      final newUser = MyUser.fromMap(map);

      expect(newUser.id, user.id);
      expect(newUser.fullName, user.fullName);
      expect(newUser.email, user.email);
      expect(newUser.photoUrl, user.photoUrl);
      expect(newUser.address, user.address);
      expect(newUser.favorite, user.favorite);
      expect(newUser.cart.length, user.cart.length);
      expect(newUser.cart.first.name, user.cart.first.name);
      expect(newUser.ordersId, user.ordersId);
      expect(newUser.date, user.date);
    });
  });
}
