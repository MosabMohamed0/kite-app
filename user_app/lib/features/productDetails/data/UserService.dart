import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';
import 'package:depi_app/features/cart/presentation/manager/cart_cubit.dart';
import 'package:flutter/foundation.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> _ensureCartExists(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      await _firestore.collection('users').doc(userId).set({'cart': []});
    } else {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('cart')) {
        await _firestore.collection('users').doc(userId).update({'cart': []});
      }
    }
  }

  Future<void> addToCart(String userId, ProductSelected product) async {
    await _ensureCartExists(userId);

    bool exists = await isProductInCart(userId, product);
    if (exists) {
      await increeseProductQuantity(
        userId,
        product.productId,
        product.productDetails['quantity'],
      );
    } else {
      await _firestore.collection('users').doc(userId).update({
        'cart': FieldValue.arrayUnion([product.toMap()]),
      });
    }
  }

  Future<bool> isProductInCart(String userId, ProductSelected product) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    List cart = userDoc['cart'] ?? [];
    bool exists = cart.any((item) {
      bool sameId = item['productId'] == product.productId;

      Map<String, dynamic> d1 = Map.from(item['productDetails']);
      Map<String, dynamic> d2 = Map.from(product.productDetails);

      d1.remove('quantity');
      d2.remove('quantity');

      return sameId && mapEquals(d1, d2);
    });
    return exists;
    // return cart.any((item) => (item['id'] == product.productId));
  }

  Future<void> increeseProductQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    List cart = userDoc['cart'] ?? [];
    for (var item in cart) {
      if (item['productId'] == productId) {
        item['productDetails']['quantity'] += quantity;
        break;
      }
    }
    await _firestore.collection('users').doc(userId).update({'cart': cart});
    // CartCubit().loadCart();
  }
}
