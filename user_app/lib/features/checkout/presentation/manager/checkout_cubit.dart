import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/order.dart';
import '../../../../core/models/order.dart' as checkout_state;
import '../../../../core/models/selectedProduct.dart';
import '../../../cart/presentation/manager/cart_cubit.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CartCubit cartCubit;

  CheckoutCubit({required this.cartCubit}) : super(const CheckoutState());

  void updateName(String value) => _updateState(name: value);
  void updateStatus(Status value) => _updateState(status: value);
  void updatePhone(String value) => _updateState(phone: value);
  void updateAddress(String value) => _updateState(address: value);
  void updateCardNumber(String value) => _updateState(cardNumber: value);
  void updateExpiryDate(String value) => _updateState(expiryDate: value);
  void updateCvv(String value) => _updateState(cvv: value);
  void updateCardholderName(String value) =>
      _updateState(cardholderName: value);
  void updatePaymentMethod(checkout_state.PaymentMethod method) =>
      _updateState(paymentMethod: method);

  void _updateState({
    String? name,
    String? phone,
    String? address,
    // String? city,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
    checkout_state.PaymentMethod? paymentMethod,
    Status? status,
  }) {
    final newState = state.copyWith(
      name: name,
      phone: phone,
      address: address,
      // city: city,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      cardholderName: cardholderName,
      paymentMethod: paymentMethod,
      status: status,
    );

    emit(newState.copyWith(isCheckoutValid: _validateCheckout(newState)));
  }

  bool _validateCheckout(CheckoutState s) {
    final hasAddress =
        s.name.isNotEmpty && s.phone.isNotEmpty && s.address.isNotEmpty;
    // && s.city.isNotEmpty;
    if (s.paymentMethod == checkout_state.PaymentMethod.cash) {
      return hasAddress;
    } else {
      final hasCard =
          s.cardNumber.isNotEmpty &&
          s.expiryDate.isNotEmpty &&
          s.cvv.isNotEmpty &&
          s.cardholderName.isNotEmpty;
      return hasAddress && hasCard;
    }
  }

  // Future<MyOrder?> confirmOrder(BuildContext context) async {
  //   if (!state.isCheckoutValid) return null;

  //   emit(state.copyWith(isSubmitting: true));

  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     emit(state.copyWith(isSubmitting: false));
  //     return null;
  //   }

  //   final orderData = {
  //     'userId': user.uid,
  //     'products': cartCubit.state.products.map((e) => e.toMap()).toList(),
  //     'totalPrice': cartCubit.total,
  //     'date': Timestamp.now(),
  //     'paymentMethod': state.paymentMethod.toString().split('.').last,
  //     'status': 'pending',
  //     'customerName': state.name,
  //     'customerPhone': state.phone,
  //     'customerAddress': state.address,
  //   };

  //   final myOrder = MyOrder.fromMap({
  //     ...orderData,
  //   }, id: FirebaseFirestore.instance.collection('orders').doc().id);

  //   final stockService = StockService();

  //   // ======================================
  //   // 1- Check stock before saving order
  //   // ======================================
  //   List<Map<String, dynamic>> insufficientItems = await stockService
  //       .checkInsufficientStockForOrder(myOrder);

  //   if (insufficientItems.isNotEmpty) {
  //     emit(state.copyWith(isSubmitting: false));

  //     showDialog(
  //       context: context,
  //       builder:
  //           (context) => AlertDialog(
  //             backgroundColor: Colors.white,
  //             title: Text(
  //               "Insufficient Stock",
  //               style: AppStyles.styleBold24Dark,
  //             ),
  //             content: SizedBox(
  //               width: double.maxFinite,
  //               child: ListView(
  //                 shrinkWrap: true,
  //                 children:
  //                     insufficientItems.map((item) {
  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               item['name'],
  //                               style: AppStyles.styleSemiBold20Dark,
  //                             ),
  //                             SizedBox(height: 2),
  //                             if (item['color'] != null && item['size'] != null)
  //                               Text(
  //                                 "(Color: ${item['color']} , Size: ${item['size']})",
  //                               ),
  //                             if (item['color'] != null && item['size'] == null)
  //                               Text("Color: ${item['color']}"),
  //                             if (item['size'] != null && item['color'] == null)
  //                               Text("Size: ${item['size']}"),
  //                             SizedBox(height: 2),
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   "Requested: ${item['requested']}",
  //                                   style: TextStyle(color: Colors.red),
  //                                 ),
  //                                 SizedBox(width: 16),
  //                                 Text(
  //                                   "Available: ${item['available']}",
  //                                   style: TextStyle(color: Colors.green),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     }).toList(),
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: Text("OK"),
  //               ),
  //             ],
  //           ),
  //     );

  //     return null;
  //   }

  //   // ======================================
  //   // 2- Save order if stock is sufficient
  //   // ======================================
  //   try {
  //     stockService.decreaseStockForOrder(myOrder);

  //     final docRef = FirebaseFirestore.instance
  //         .collection('orders')
  //         .doc(myOrder.id);

  //     await docRef.set(myOrder.toMap());

  //     await cartCubit.clearCart();

  //     emit(state.copyWith(isSubmitting: false));

  //     return myOrder;
  //   } catch (e) {
  //     emit(state.copyWith(isSubmitting: false));
  //     rethrow;
  //   }
  // }

  Future<MyOrder?> confirmOrder() async {
    if (!state.isCheckoutValid) return null;

    emit(state.copyWith(isSubmitting: true));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(state.copyWith(isSubmitting: false));
      return null;
    }

    final orderData = {
      'userId': user.uid,
      'products': cartCubit.state.products.map((e) => e.toMap()).toList(),
      'totalPrice': cartCubit.total,
      'date': Timestamp.now(),
      'paymentMethod': state.paymentMethod.toString().split('.').last,
      'status': 'pending',
      'customerName': state.name,
      'customerPhone': state.phone,
      'customerAddress': state.address,

    };

    try {
      final docRef = FirebaseFirestore.instance.collection('orders').doc();

      final myOrder = MyOrder.fromMap({
        ...orderData,
      }, id: docRef.id);

      await docRef.set(myOrder.toMap());

      await cartCubit.clearCart();

      emit(state.copyWith(isSubmitting: false));

      return myOrder;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
      rethrow;
    }
  }

  Stream<int> getUserOrdersCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<MyOrder>> getUserOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // print("No user logged in");
      return Stream.value([]);
    }

    // print("Fetching orders for user: ${user.uid}");

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          // print("Orders snapshot received: ${snapshot.docs.length} documents");

          final orders =
              snapshot.docs.map((doc) {
                final data = doc.data();
                // print("Order data: ${doc.id} -> $data");

                try {
                  return MyOrder(
                    id: doc.id,
                    userId: data['userId'] ?? '',
                    products:
                        data['products'] != null
                            ? List.from(data['products'])
                                .map(
                                  (e) => ProductSelected.fromMap(
                                    Map<String, dynamic>.from(e),
                                  ),
                                )
                                .toList()
                            : [],

                    totalPrice: (data['totalPrice'] ?? 0).toDouble(),
                    date: data['date'] ?? Timestamp.now(),
                    status: Status.values.firstWhere(
                      (s) =>
                          s.toString().split('.').last.toLowerCase() ==
                          ((data['status'] ?? 'pending')
                              .toString()
                              .toLowerCase()),
                      orElse: () => Status.pending,
                    ),
                    paymentMethod: PaymentMethod.values.firstWhere(
                      (p) =>
                          p.toString().split('.').last.toLowerCase() ==
                          ((data['paymentMethod'] ?? 'cash')
                              .toString()
                              .toLowerCase()),
                      orElse: () => PaymentMethod.cash,
                    ),
                    // address: data['address'] != null ? List<String>.from(data['address']) : [],
                    customerAddress: data['customerAddress'],
                    customerName: data['customerName'],
                    customerPhone: data['customerPhone'],
                  );
                } catch (e) {
                  // print("Error parsing order ${doc.id}: $e");
                  rethrow;
                }
              }).toList();
          return orders;
        })
        .handleError((error) {
          return <MyOrder>[];
        });
  }

  Stream<List<MyOrder>>? getLastThreeOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) {
          final orders =
              snapshot.docs.map((doc) {
                final data = doc.data();

                try {
                  return MyOrder(
                    id: doc.id,
                    userId: data['userId'] ?? '',
                    products:
                        data['products'] != null
                            ? List.from(data['products'])
                                .map(
                                  (e) => ProductSelected.fromMap(
                                    Map<String, dynamic>.from(e),
                                  ),
                                )
                                .toList()
                            : [],

                    totalPrice: (data['totalPrice'] ?? 0).toDouble(),
                    date: data['date'] ?? Timestamp.now(),
                    status: Status.values.firstWhere(
                      (s) =>
                          s.toString().split('.').last.toLowerCase() ==
                          ((data['status'] ?? 'pending')
                              .toString()
                              .toLowerCase()),
                      orElse: () => Status.pending,
                    ),
                    paymentMethod: PaymentMethod.values.firstWhere(
                      (p) =>
                          p.toString().split('.').last.toLowerCase() ==
                          ((data['paymentMethod'] ?? 'cash')
                              .toString()
                              .toLowerCase()),
                      orElse: () => PaymentMethod.cash,
                    ),
                    // address: data['address'] != null ? List<String>.from(data['address']) : [],
                    customerAddress: data['customerAddress'] ?? '',
                    customerName: data['customerName'] ?? user.displayName,
                    customerPhone: data['customerPhone'] ?? user.phoneNumber,
                  );
                } catch (e) {
                  rethrow;
                }
              }).toList();
          return orders;
        })
        .handleError((error) {
          return <MyOrder>[];
        });
  }

  Future<void> updateOrderStatus(String orderId, Status newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': newStatus.toString().split('.').last},
      );

      emit(state.copyWith(status: newStatus));
    } catch (e) {
      // print("Error updating order status: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getUserPreviousAddresses(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final data =
              snapshot.docs.map((doc) {
                final d = doc.data();
                return {
                  "name": d["customerName"],
                  "address": d["customerAddress"],
                  "phone": d["customerPhone"],
                };
              }).toList();

          final seen = <String>{};
          final unique = <Map<String, dynamic>>[];

          for (var item in data) {
            final key = "${item['name']}_${item['address']}_${item['phone']}";
            if (!seen.contains(key)) {
              seen.add(key);
              unique.add(item);
            }
          }

          return unique;
        });
  }

  bool areAddressFieldsValid(CheckoutCubit cubit) {
    return state.name.isNotEmpty &&
        state.phone.isNotEmpty &&
        state.address.isNotEmpty;
  }
}
