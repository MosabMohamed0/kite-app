import 'package:flutter_test/flutter_test.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

void main() {
  group('ProductSelected Model Tests', () {
    
    // Helper function to create a sample ProductSelected
    ProductSelected createSampleProduct() {
      return ProductSelected(
        id: 'p1',
        productId: 'prod123',
        name: 'iPhone 14',
        price: 999.99,
        photoURL: 'https://example.com/iphone.jpg',
        brand: 'Apple',
        category: 'Electronics',
        productDetails: {'color': 'black', 'storage': '128GB'},
      );
    }

    test('should create ProductSelected object correctly', () {
      final product = createSampleProduct();

      expect(product.id, 'p1');
      expect(product.productId, 'prod123');
      expect(product.name, 'iPhone 14');
      expect(product.price, 999.99);
      expect(product.photoURL, 'https://example.com/iphone.jpg');
      expect(product.brand, 'Apple');
      expect(product.category, 'Electronics');
      expect(product.productDetails['color'], 'black');
      expect(product.productDetails['storage'], '128GB');
    });

    test('should convert ProductSelected to Map correctly', () {
      final product = createSampleProduct();
      final map = product.toMap();

      expect(map['id'], 'p1');
      expect(map['productId'], 'prod123');
      expect(map['name'], 'iPhone 14');
      expect(map['price'], 999.99);
      expect(map['photoURL'], 'https://example.com/iphone.jpg');
      expect(map['brand'], 'Apple');
      expect(map['category'], 'Electronics');
      expect(map['productDetails']['color'], 'black');
      expect(map['productDetails']['storage'], '128GB');
    });

    test('should create ProductSelected from Map correctly', () {
      final map = {
        'id': 'p1',
        'productId': 'prod123',
        'name': 'iPhone 14',
        'price': 999.99,
        'photoURL': 'https://example.com/iphone.jpg',
        'brand': 'Apple',
        'category': 'Electronics',
        'productDetails': {'color': 'black', 'storage': '128GB'},
      };

      final product = ProductSelected.fromMap(map);

      expect(product.id, 'p1');
      expect(product.productId, 'prod123');
      expect(product.name, 'iPhone 14');
      expect(product.price, 999.99);
      expect(product.photoURL, 'https://example.com/iphone.jpg');
      expect(product.brand, 'Apple');
      expect(product.category, 'Electronics');
      expect(product.productDetails['color'], 'black');
      expect(product.productDetails['storage'], '128GB');
    });

    test('toMap and fromMap should be consistent', () {
      final product = createSampleProduct();
      final map = product.toMap();
      final newProduct = ProductSelected.fromMap(map);

      expect(newProduct.id, product.id);
      expect(newProduct.productId, product.productId);
      expect(newProduct.name, product.name);
      expect(newProduct.price, product.price);
      expect(newProduct.photoURL, product.photoURL);
      expect(newProduct.brand, product.brand);
      expect(newProduct.category, product.category);
      expect(newProduct.productDetails['color'], product.productDetails['color']);
      expect(newProduct.productDetails['storage'], product.productDetails['storage']);
    });
  });
}
