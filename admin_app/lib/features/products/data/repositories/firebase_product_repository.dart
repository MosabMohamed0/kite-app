import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/product_model.dart';

class FirebaseProductRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Product>> getProducts() async {
    try {
      final snapshot =
          await _db
              .collection('products')
              .orderBy('date', descending: true)
              .get();

      final products =
          snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final docRef = _db.collection('products').doc();
      final productWithId = product.copyWith(id: docRef.id);
      await docRef.set(productWithId.toMap());
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _db.collection('products').doc(product.id).update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await _deleteImageFromSupabase(product.photoUrl);

      await _db.collection('products').doc(product.id).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  Future<void> _deleteImageFromSupabase(String photoUrl) async {
    try {
      // 1. بنجيب اسم الملف من الرابط الطويل
      // الرابط بيبقى: https://.../storage/v1/object/public/product_images/public/1731505677054.png
      // إحنا محتاجين آخر جزء بس اللي هو 'public/1731505677054.png'

      final uri = Uri.parse(photoUrl);
      final pathSegments = uri.pathSegments;
      // بنشيل أول 4 أجزاء من المسار (storage, v1, object, public, product_images)
      final filePath = pathSegments.sublist(5).join('/');

      if (filePath.isEmpty) {
        print('Could not parse file path from URL: $photoUrl');
        return;
      }

      await _supabase.storage.from('product_images').remove([filePath]);

      print('Successfully deleted image from Supabase: $filePath');
    } catch (e) {
      print('Error deleting image from Supabase: $e');
    }
  }
}
