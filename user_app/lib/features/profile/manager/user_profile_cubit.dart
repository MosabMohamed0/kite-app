import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  Future<void> loadUserProfile() async {
    emit(UserProfileLoading());

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(UserProfileError("Please Log In First"));
        return;
      }

      final uid = currentUser.uid;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) {
        emit(UserProfileError("User Data Not Found"));
        return;
      }

      final data = doc.data();
      if (data == null) {
        emit(UserProfileError("User Data Empty"));
        return;
      }
      List<Map<String, dynamic>> cart = [];
      List<String> favorite = [];
      String? photoUrl;

      if (data['cart'] != null && data['cart'] is List) {
        cart = List<Map<String, dynamic>>.from(
          (data['cart'] as List).map(
            (e) => Map<String, dynamic>.from(e as Map),
          ),
        );
      }

      if (data['favorite'] != null && data['favorite'] is List) {
        favorite = List<String>.from(
          (data['favorite'] as List).map((e) => e.toString()),
        );
      }

      if (data['photoUrl'] != null) {
        photoUrl = data['photoUrl'].toString();
      }

      emit(
        UserProfileLoaded(
          name: data['fullName'] ?? 'Unknown',
          email: data['email'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          cart: cart,
          favorite: favorite,
          photoUrl: photoUrl,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(UserProfileError("Authentication Error ${e.message}"));
    } on FirebaseException catch (e) {
      emit(UserProfileError("Database Error ${e.message}"));
    } catch (e) {
      emit(UserProfileError("Unexpected Error ${e.toString()}"));
    }
  }

  Stream<int> getUserFavoriteCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) return 0;

          final fav = data['favorite'];
          if (fav is List) {
            return fav.length;
          } else {
            return 0;
          }
        });
  }

  Stream<int> getUserCartCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) return 0;

          final cart = data['cart'];
          if (cart is List) {
            return cart.length;
          } else {
            return 0;
          }
        });
  }
}
