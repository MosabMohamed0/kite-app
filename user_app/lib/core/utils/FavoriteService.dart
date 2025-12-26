import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addToFavorite(String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.set({
      'favorite': FieldValue.arrayUnion([productId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromFavorite(String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'favorite': FieldValue.arrayRemove([productId]),
    });
  }

  // Future<bool> isFavorite(String userId, String productId) async {
  //   final snapshot = await _firestore.collection('users').doc(userId).get();
  //   if (!snapshot.exists) return false;

  //   final data = snapshot.data();
  //   final favoriteList = data?['favorite'] as List<dynamic>? ?? [];
  //   return favoriteList.contains(productId);
  // }

  Future<List<String>> getAllFavorites() async {
    try {
      final snapshot = await _firestore.collection("users").doc(userId).get();

      if (!snapshot.exists) return [];

      final data = snapshot.data();
      final favoriteList = data?['favorite'] as List<dynamic>? ?? [];

      return favoriteList.map((e) => e.toString()).toList();
    } catch (e) {
      print("Error in getAllFavorites: $e");
      return [];
    }
  }

  // Stream<List<String>> favoriteIdsStream(String userId) {
  //   return _firestore.collection('users').doc(userId).snapshots().map((
  //     snapshot,
  //   ) {
  //     if (!snapshot.exists) return <String>[];
  //     final data = snapshot.data();
  //     final favoriteList = data?['favorite'] as List<dynamic>? ?? [];
  //     return favoriteList.map((e) => e.toString()).toList();
  //   });
  // }

  Stream<List<Product>> favoriteProductsStream() {
    return _firestore.collection('users').doc(userId).snapshots().asyncMap((
      snapshot,
    ) async {
      if (!snapshot.exists) return [];

      final favoriteIds = List<String>.from(snapshot.data()?['favorite'] ?? []);
      if (favoriteIds.isEmpty) return [];

      final productSnapshots =
          await _firestore
              .collection('products')
              .where(FieldPath.documentId, whereIn: favoriteIds)
              .get();

      return productSnapshots.docs
          .map((doc) => Product.fromMap(doc.data()))
          .toList();
    });
  }
}
