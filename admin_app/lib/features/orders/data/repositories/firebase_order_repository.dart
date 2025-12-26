import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/my_order_model.dart';

class FirebaseOrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseOrderRepository();

  Future<List<MyOrder>> getOrders() async {
    try {
      final snapshot =
          await _db
              .collection('orders')
              .orderBy('date', descending: true)
              .get();

      final orders =
          snapshot.docs.map((doc) => MyOrder.fromMap(doc.data())).toList();

      return orders;
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': newStatus.name,
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
}
