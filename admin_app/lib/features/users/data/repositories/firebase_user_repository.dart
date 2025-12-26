import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/my_user_model.dart';

class FirebaseUserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Map<String, MyUser> _userCache = {};

  Future<MyUser?> getUserById(String userId) async {
    try {
      if (_userCache.containsKey(userId)) {
        return _userCache[userId];
      }

      final doc = await _db.collection('users').doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      final user = MyUser.fromMap(doc.data()!);
      _userCache[userId] = user;

      return user;
    } catch (e) {
      print('Error fetching user $userId: $e');
      return null;
    }
  }
}
