import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper function to create test products
  List<Product> createTestProducts() {
    return [
      Product(
        id: '1',
        name: 'iPhone 14',
        price: 999.99,
        photoUrl: 'https://example.com/iphone.jpg',
        comments: [],
        rate: 4.5,
        reviews: 100,
        brand: 'Apple',
        category: 'Electronics',
        description: 'Latest iPhone',
        instruction: ['Use with care'],
        productAttributeType: ProductAttributeType.color,
        stock: 50,
        date: Timestamp.now(),
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy',
        price: 799.99,
        photoUrl: 'https://example.com/samsung.jpg',
        comments: [],
        rate: 4.3,
        reviews: 80,
        brand: 'Samsung',
        category: 'Electronics',
        description: 'Latest Samsung',
        instruction: ['Handle carefully'],
        productAttributeType: ProductAttributeType.color,
        stock: 30,
        date: Timestamp.now(),
      ),
      Product(
        id: '3',
        name: 'Nike Shoes',
        price: 150.00,
        photoUrl: 'https://example.com/nike.jpg',
        comments: [],
        rate: 4.8,
        reviews: 200,
        brand: 'Nike',
        category: 'Fashion',
        description: 'Comfortable shoes',
        instruction: ['Clean regularly'],
        productAttributeType: ProductAttributeType.size,
        stock: 100,
        date: Timestamp.now(),
      ),
    ];
  }

  group('Product Model Tests', () {
    test('should create Product from map', () {
      // Arrange
      final map = {
        'id': '1',
        'name': 'Test Product',
        'price': 99.99,
        'photoUrl': 'https://example.com/test.jpg',
        'comments': [],
        'rate': 4.5,
        'reviews': 50,
        'brand': 'Test Brand',
        'category': 'Test Category',
        'description': 'Test Description',
        'instruction': ['Test instruction'],
        'productAttributeType': 'color',
        'stock': 10,
        'date': Timestamp.now(),
      };

      // Act
      final product = Product.fromMap(map);

      // Assert
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.price, 99.99);
      expect(product.brand, 'Test Brand');
      expect(product.category, 'Test Category');
    });

    test('should convert Product to map', () {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 99.99,
        photoUrl: 'https://example.com/test.jpg',
        comments: [],
        rate: 4.5,
        reviews: 50,
        brand: 'Test Brand',
        category: 'Test Category',
        description: 'Test Description',
        instruction: ['Test instruction'],
        productAttributeType: ProductAttributeType.color,
        stock: 10,
        date: Timestamp.now(),
      );

      // Act
      final map = product.toMap();

      // Assert
      expect(map['id'], '1');
      expect(map['name'], 'Test Product');
      expect(map['price'], 99.99);
      expect(map['brand'], 'Test Brand');
      expect(map['category'], 'Test Category');
    });

    test('should handle ProductAttributeType conversion', () {
      // Test stringToAttributeType
      expect(
        Product.stringToAttributeType('color'),
        ProductAttributeType.color,
      );
      expect(
        Product.stringToAttributeType('size'),
        ProductAttributeType.size,
      );
      expect(
        Product.stringToAttributeType('both'),
        ProductAttributeType.both,
      );
      expect(
        Product.stringToAttributeType('unknown'),
        ProductAttributeType.none,
      );
      expect(
        Product.stringToAttributeType(null),
        ProductAttributeType.none,
      );
    });
  });

  group('Product Filtering Logic Tests', () {
    late List<Product> products;

    setUp(() {
      products = createTestProducts();
    });

    test('should filter products by category', () {
      // Arrange
      const category = 'Electronics';

      // Act
      final filtered =
          products.where((p) => p.category == category).toList();

      // Assert
      expect(filtered.length,2);
      expect(filtered.every((p) => p.category == 'Electronics'), true);
    });

    test('should filter products by price range', () {
      // Arrange
      const minPrice = 100.0;
      const maxPrice = 200.0;

      // Act
      final filtered = products
          .where((p) => p.price >= minPrice && p.price <= maxPrice)
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.name, 'Nike Shoes');
    });

    test('should filter products by search query', () {
      // Arrange
      const searchQuery = 'iphone';

      // Act
      final filtered = products
          .where((p) => p.name.toLowerCase().contains(searchQuery))
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.name, 'iPhone 14');
    });

    test('should return all products when category is "All"', () {
      // Arrange
      const category = 'All';

      // Act
      final filtered = category == 'All'
          ? products
          : products.where((p) => p.category == category).toList();

      // Assert
      expect(filtered.length, 3);
    });

    test('should return empty list when no products match filter', () {
      // Arrange
      const category = 'NonExistent';

      // Act
      final filtered =
          products.where((p) => p.category == category).toList();

      // Assert
      expect(filtered.isEmpty, true);
    });
  });

  group('Product Sorting Logic Tests', () {
    late List<Product> products;

    setUp(() {
      products = createTestProducts();
    });

    test('should sort products by price low to high', () {
      // Act
      products.sort((a, b) => a.price.compareTo(b.price));

      // Assert
      expect(products.first.name, 'Nike Shoes');
      expect(products.last.name, 'iPhone 14');
      expect(products.first.price, 150.00);
      expect(products.last.price, 999.99);
    });

    test('should sort products by price high to low', () {
      // Act
      products.sort((a, b) => b.price.compareTo(a.price));

      // Assert
      expect(products.first.name, 'iPhone 14');
      expect(products.last.name, 'Nike Shoes');
      expect(products.first.price, 999.99);
      expect(products.last.price, 150.00);
    });

    test('should sort products by rating', () {
      // Act
      products.sort((a, b) => b.rate.compareTo(a.rate));

      // Assert
      expect(products.first.name, 'Nike Shoes');
      expect(products.first.rate, 4.8);
    });
  });

  group('Combined Filter and Sort Tests', () {
    late List<Product> products;

    setUp(() {
      products = createTestProducts();
    });

    test('should filter by category and sort by price', () {
      // Arrange
      const category = 'Electronics';

      // Act - Filter
      var filtered =
          products.where((p) => p.category == category).toList();
      
      // Act - Sort
      filtered.sort((a, b) => a.price.compareTo(b.price));

      // Assert
      expect(filtered.length, 2);
      expect(filtered.first.name, 'Samsung Galaxy');
      expect(filtered.last.name, 'iPhone 14');
    });

    test('should filter by price range and search query', () {
      // Arrange
      const minPrice = 0.0;
      const maxPrice = 1000.0;
      const searchQuery = 'samsung';

      // Act
      final filtered = products
          .where((p) =>
              p.price >= minPrice &&
              p.price <= maxPrice &&
              p.name.toLowerCase().contains(searchQuery))
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.name, 'Samsung Galaxy');
    });

    test('should apply all filters: category, price, and search', () {
      // Arrange
      const category = 'Electronics';
      const minPrice = 700.0;
      const maxPrice = 1000.0;
      const searchQuery = 'phone';

      // Act
      final filtered = products
          .where((p) =>
              p.category == category &&
              p.price >= minPrice &&
              p.price <= maxPrice &&
              p.name.toLowerCase().contains(searchQuery))
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.name, 'iPhone 14');
    });
  });

  group('Price Range Tests', () {
    test('should validate price range values', () {
      // Arrange
      const minPrice = 0.0;
      const maxPrice = 50000.0;
      const userMinPrice = 100.0;
      const userMaxPrice = 1000.0;

      // Assert
      expect(userMinPrice >= minPrice, true);
      expect(userMaxPrice <= maxPrice, true);
      expect(userMinPrice <= userMaxPrice, true);
    });

    test('should clamp price values within range', () {
      // Arrange
      const minPrice = 0.0;
      const maxPrice = 50000.0;
      var userMinPrice = -100.0;
      var userMaxPrice = 60000.0;

      // Act
      userMinPrice = userMinPrice.clamp(minPrice, maxPrice);
      userMaxPrice = userMaxPrice.clamp(minPrice, maxPrice);

      // Assert
      expect(userMinPrice, 0.0);
      expect(userMaxPrice, 50000.0);
    });
  });

  group('Search Query Tests', () {
    late List<Product> products;

    setUp(() {
      products = createTestProducts();
    });

    test('should handle empty search query', () {
      // Arrange
      const searchQuery = '';

      // Act
      final filtered = searchQuery.isEmpty
          ? products
          : products
              .where((p) => p.name.toLowerCase().contains(searchQuery))
              .toList();

      // Assert
      expect(filtered.length, 3);
    });

    test('should handle case-insensitive search', () {
      // Arrange
      const searchQuery = 'IPHONE';

      // Act
      final filtered = products
          .where(
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.name, 'iPhone 14');
    });

    test('should handle search with spaces', () {
      // Arrange
      const searchQuery = '  iphone  ';

      // Act
      final filtered = products
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.trim().toLowerCase()))
          .toList();

      // Assert
      expect(filtered.length, 1);
    });
  });

  group('Edge Cases Tests', () {
    test('should handle empty product list', () {
      // Arrange
      final emptyList = <Product>[];

      // Act
      final filtered = emptyList
          .where((p) => p.category == 'Electronics')
          .toList();

      // Assert
      expect(filtered.isEmpty, true);
    });

    test('should handle product with zero price', () {
      // Arrange
      final product = Product(
        id: '999',
        name: 'Free Product',
        price: 0.0,
        photoUrl: 'https://example.com/free.jpg',
        comments: [],
        rate: 5.0,
        reviews: 1000,
        brand: 'Free Brand',
        category: 'Free',
        description: 'Free product',
        instruction: [],
        productAttributeType: ProductAttributeType.none,
        stock: 999,
        date: Timestamp.now(),
      );

      // Assert
      expect(product.price, 0.0);
      expect(product.price >= 0, true);
    });

    test('should handle product with missing values', () {
      // Arrange
      final map = {
        'id': '',
        'name': '',
        'price': 0,
        'photoUrl': '',
        'comments': [],
        'rate': 0,
        'reviews': 0,
        'brand': '',
        'category': '',
        'description': '',
        'instruction': [],
        'productAttributeType': null,
        'stock': null,
      };

      // Act
      final product = Product.fromMap(map);

      // Assert
      expect(product.id, '');
      expect(product.name, '');
      expect(product.price, 0.0);
      expect(product.productAttributeType, ProductAttributeType.none);
    });
  });
}