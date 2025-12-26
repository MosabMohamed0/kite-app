import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/models/review.dart';

class ProductReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReviewToProduct(String productId, Review review) async {
    final docRef = _firestore.collection('products').doc(productId);

    await docRef.update({
      'comments': FieldValue.arrayUnion([review.toMap()]),
    });

    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();
    if (data == null) return;

    final commentsData = (data['comments'] as List<dynamic>?) ?? [];
    final comments = commentsData.map((e) => Review.fromMap(e)).toList();

    double totalRate = comments.fold(0, (sum, r) => sum + r.rate);
    double avgRate = comments.isEmpty ? 0.0 : totalRate / comments.length;

    await docRef.update({
      'rate': avgRate,
      'reviews': comments.length,
    });
  }

  Stream<Product> getProductStream(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((snapshot) => Product.fromMap(snapshot.data()!));
  }
}
