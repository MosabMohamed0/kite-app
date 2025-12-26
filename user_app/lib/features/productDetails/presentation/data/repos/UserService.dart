import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:depi_app/core/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore
              .collection(
                'users',
              )
              .doc(userId)
              .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }

  Future<String?> getCurrentUserName() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('No user logged in');
        return null;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['fullName'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting current user name: $e');
      return null;
    }
  }

  Future<MyUser?> getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('No user logged in');
        return null;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        data['id'] = userDoc.id;
        return MyUser.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<MyUser?> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        data['id'] = userDoc.id;
        return MyUser.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
