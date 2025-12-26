import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/models/selectedProduct.dart';
import 'package:depi_app/core/models/user.dart';

class StockService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =======================================
  /// Check which products in the cart are insufficient
  /// =======================================
  Future<List<Map<String, dynamic>>> checkInsufficientStockForCart(
    List<ProductSelected> cart,
  ) async {
    List<Map<String, dynamic>> insufficientItems = [];

    for (var item in cart) {
      final stockCheck = await checkStock(
        productID: item.productId,
        color: item.productDetails['color'],
        size: item.productDetails['size'],
        quantity: item.productDetails['quantity'],
      );


      if (!stockCheck['available']) {
        insufficientItems.add({
          'productId': item.productId,
          'name':item.name,
          'color': item.productDetails['color'],
          'size': item.productDetails['size'],
          'requested': item.productDetails['quantity'],
          'available': stockCheck['availableQty'],
        });
      }
    }

    return insufficientItems; 
  }

  /// =======================================
  /// Check stock for one product
  /// Returns: { 'available': bool, 'availableQty': int }
  /// =======================================
  Future<Map<String, dynamic>> checkStock({
    required String productID,
    String? color,
    String? size,
    required int quantity,
  }) async {
    final ref = _firestore.collection('products').doc(productID);
    final snapshot = await ref.get();

    if (!snapshot.exists) return {'available': false, 'availableQty': 0};

    dynamic stock = snapshot['stock'];
    String attributeStr = snapshot['productAttributeType'];
    ProductAttributeType type = Product.stringToAttributeType(attributeStr);

    int availableQty = 0;
    bool available = false;

    switch (type) {
      case ProductAttributeType.color:
        if (color == null) return {'available': false, 'availableQty': 0};
        availableQty = stock[color] ?? 0;
        available = availableQty >= quantity;
        break;

      case ProductAttributeType.size:
        if (size == null) return {'available': false, 'availableQty': 0};
        availableQty = stock[size] ?? 0;
        available = availableQty >= quantity;
        break;

      case ProductAttributeType.both:
        if (color == null || size == null)
          return {'available': false, 'availableQty': 0};
        Map<String, dynamic> colorMap = Map<String, dynamic>.from(
          stock[color] ?? {},
        );
        availableQty = colorMap[size] ?? 0;
        available = availableQty >= quantity;
        break;

      case ProductAttributeType.none:
        availableQty = stock["total"] ?? 0;
        available = availableQty >= quantity;
        break;
    }

    return {'available': available, 'availableQty': availableQty};
  }
  // /// =======================================
  // /// Check if an entire order has enough stock
  // /// =======================================
  // Future<bool> checkStockForOrder(MyOrder order) async {
  //   for (var item in order.products) {
  //     bool available = await checkStock(
  //       productID: item.productId,
  //       color: item.productDetails['color'],
  //       size: item.productDetails['size'],
  //       quantity: item.productDetails['quantity'],
  //     );
  //     if (!available) {
  //       return false; // لو أي منتج مش كفاية ستوك
  //     }
  //   }
  //   return true; // كل المنتجات كفاية
  // }

  // /// =======================================
  // /// Check stock for one product
  // /// =======================================
  // Future<bool> checkStock({
  //   required String productID,
  //   String? color,
  //   String? size,
  //   required int quantity,
  // }) async {
  //   final ref = _firestore.collection('products').doc(productID);
  //   final snapshot = await ref.get();

  //   if (!snapshot.exists) return false;

  //   dynamic stock = snapshot['stock'];
  //   String attributeStr = snapshot['productAttributeType'];
  //   ProductAttributeType type = Product.stringToAttributeType(attributeStr);

  //   switch (type) {
  //     case ProductAttributeType.color:
  //       if (color == null) return false;
  //       int current = (stock[color] ?? 0);
  //       return current >= quantity;

  //     case ProductAttributeType.size:
  //       if (size == null) return false;
  //       int current = (stock[size] ?? 0);
  //       return current >= quantity;

  //     case ProductAttributeType.both:
  //       if (color == null || size == null) return false;
  //       Map<String, dynamic> colorMap = Map<String, dynamic>.from(
  //         stock[color] ?? {},
  //       );
  //       int current = (colorMap[size] ?? 0);
  //       return current >= quantity;

  //     case ProductAttributeType.none:
  //       int current = (stock["total"] ?? 0);
  //       return current >= quantity;
  //   }
  // }

  /// =======================================
  ///  Decrease stock for a full order
  /// =======================================
  Future<void> decreaseStockForcart(List<ProductSelected> cart) async {
    for (var item in cart) {
      await decreaseStock(
        productID: item.productId,
        color: item.productDetails['color'],
        size: item.productDetails['size'],
        quantity: item.productDetails['quantity'],
      );
    }
  }

  /// =======================================
  ///  Decrease stock for one product
  /// =======================================
  Future<void> decreaseStock({
    required String productID,
    String? color,
    String? size,
    required int quantity,
  }) async {
    final ref = _firestore.collection('products').doc(productID);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);

      if (!snapshot.exists) return;

      /// -------------------------------
      /// 1- Read product data
      /// -------------------------------
      dynamic stock = snapshot['stock'];
      String attributeStr = snapshot['productAttributeType'];
      ProductAttributeType type = Product.stringToAttributeType(attributeStr);

      /// -------------------------------
      /// 2- Switch by attribute type
      /// -------------------------------
      switch (type) {
        /// =======================================
        /// COLOR ONLY
        /// =======================================
        case ProductAttributeType.color:
          if (color == null) throw Exception("Color required");

          int current = (stock[color] ?? 0);
          if (current < quantity) throw Exception("Not enough stock");

          stock[color] = current - quantity;
          break;

        /// =======================================
        /// SIZE ONLY
        /// =======================================
        case ProductAttributeType.size:
          if (size == null) throw Exception("Size required");

          int current = (stock[size] ?? 0);
          if (current < quantity) throw Exception("Not enough stock");

          stock[size] = current - quantity;
          break;

        /// =======================================
        /// BOTH (COLOR + SIZE)
        /// =======================================
        case ProductAttributeType.both:
          if (color == null || size == null) {
            throw Exception("Color and Size required");
          }

          Map<String, dynamic> colorMap = Map<String, dynamic>.from(
            stock[color] ?? {},
          );

          int current = (colorMap[size] ?? 0);
          if (current < quantity) throw Exception("Not enough stock");

          colorMap[size] = current - quantity;

          stock[color] = colorMap;
          break;

        /// =======================================
        /// NONE (total only)
        /// =======================================
        case ProductAttributeType.none:
          int current = (stock["total"] ?? 0);
          if (current < quantity) throw Exception("Not enough stock");

          stock["total"] = current - quantity;
          break;
      }

      /// -------------------------------
      /// 3- Update Firestore
      /// -------------------------------
      transaction.update(ref, {"stock": stock});
    });
  }
}
