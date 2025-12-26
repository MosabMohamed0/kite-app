import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cart_state.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
    : super(const CartState(products: [], totalPrice: 0, isLoading: true));

  final TextEditingController couponController = TextEditingController();

  // متغيرات للـ UI
  double withoutTax = 0;
  double tax = 0;
  double shipping = 20;
  double total = 0;

  // نسبة الخصم (0.0 = لا خصم)
  double discountPercent = 0;

  // جلب الكارت من Firebase
  Future<void> loadCart() async {
    emit(const CartState(products: [], totalPrice: 0, isLoading: true));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const CartState(products: [], totalPrice: 0, isLoading: false));
      return;
    }

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = doc.data();

    if (data == null || data['cart'] == null) {
      _calculateTotals([]);
      return;
    }

    final rawCart = data['cart'];
    List<dynamic> cartList = [];

    if (rawCart is List) {
      cartList = rawCart;
    } else if (rawCart is Map) {
      final entries = rawCart.entries.toList();
      entries.sort((a, b) {
        final aKey = int.tryParse(a.key.toString()) ?? 0;
        final bKey = int.tryParse(b.key.toString()) ?? 0;
        return aKey.compareTo(bKey);
      });
      cartList = entries.map((e) => e.value).toList();
    }

    final items =
        cartList
            .map((e) => ProductSelected.fromMap(Map<String, dynamic>.from(e)))
            .toList();

    _calculateTotals(items);
  }

  // تحديث Firestore
  Future<void> _updateFirestore(List<ProductSelected> items) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartMapped = items.map((e) => e.toMap()).toList();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'cart': cartMapped,
    });
  }

  // زيادة الكمية
  Future<void> increaseQty(int index) async {
    final updated = List<ProductSelected>.from(state.products);
    final item = updated[index];
    final details = Map<String, dynamic>.from(item.productDetails);
    details['quantity'] = (details['quantity'] ?? 1) + 1;

    updated[index] = ProductSelected(
      id: item.id,
      productId: item.productId,
      name: item.name,
      price: item.price,
      photoURL: item.photoURL,
      brand: item.brand,
      category: item.category,
      productDetails: details,
    );

    _calculateTotals(updated);
    await _updateFirestore(updated);
  }

  // نقصان الكمية
  Future<void> decreaseQty(int index) async {
    final updated = List<ProductSelected>.from(state.products);
    final item = updated[index];
    final details = Map<String, dynamic>.from(item.productDetails);
    final current = details['quantity'] ?? 1;
    if (current <= 1) return;

    details['quantity'] = current - 1;

    updated[index] = ProductSelected(
      id: item.id,
      productId: item.productId,
      name: item.name,
      price: item.price,
      photoURL: item.photoURL,
      brand: item.brand,
      category: item.category,
      productDetails: details,
    );

    _calculateTotals(updated);
    await _updateFirestore(updated);
  }

  // حذف منتج
  Future<void> removeItem(int index) async {
    final updated = List<ProductSelected>.from(state.products)..removeAt(index);
    _calculateTotals(updated);
    await _updateFirestore(updated);
  }

  // تطبيق كوبون
  void applyCoupon(BuildContext context) {
    final code = couponController.text.trim();
    if (code.isEmpty) {
      discountPercent = 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 8,
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                "Please enter a coupon code",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          duration: Duration(milliseconds: 1600),
        ),
      );

      return;
    }

    if (code.toUpperCase() == 'SAVE1') {
      discountPercent = 0.10; // خصم 10%
      _calculateTotals(state.products);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 8,
          backgroundColor: Colors.green.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                "Coupon applied: 10% off",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          duration: Duration(milliseconds: 1600),
        ),
      );
    } else {
      discountPercent = 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 8,
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                "Invalid coupon",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          duration: Duration(milliseconds: 1600),
        ),
      );
    }

    _calculateTotals(state.products); // إعادة الحساب مع الخصم
  }

  // حساب الأسعار مع الخصم
  void _calculateTotals(List<ProductSelected> items) {
    double newWithoutTax = 0;
    double shipping = 20;

    for (var it in items) {
      final qty = it.productDetails['quantity'] ?? 1;
      newWithoutTax += it.price * (qty is int ? qty : (qty as num).toDouble());
    }

    double tax;
    double totalBeforeDiscount;
    if (newWithoutTax > 1000) {
      tax = newWithoutTax * 0.08;
      shipping = 0;
      totalBeforeDiscount = newWithoutTax + tax;
    } else {
      tax = (newWithoutTax + shipping) * 0.08;
      totalBeforeDiscount = newWithoutTax + tax + shipping;
    }

    // تطبيق الخصم
    total = totalBeforeDiscount - (totalBeforeDiscount * discountPercent);

    this.withoutTax = newWithoutTax;
    this.tax = tax;
    this.shipping = shipping;

    emit(CartState(products: items, totalPrice: total, isLoading: false));
  }

  Future<void> clearCart() async {
    // تصفير الـ state
    emit(const CartState(products: [], totalPrice: 0, isLoading: false));

    // إعادة تصفير المتغيرات الحسابية
    withoutTax = 0;
    tax = 0;
    shipping = 20;
    total = 0;

    // تحديث Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'cart': []},
      );
    }
  }

  Stream<List<Map<String, dynamic>>> getUserCartStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) return [];
          final cart = data['cart'];
          if (cart is List) {
            return cart.map((item) => Map<String, dynamic>.from(item)).toList();
          } else {
            return [];
          }
        });
  }

  void startCartListener() {
    getUserCartStream().listen((cartData) {
      final items = cartData.map((e) => ProductSelected.fromMap(e)).toList();
      _calculateTotals(items);
    });
  }

  // Future<void> updateCart(List<ProductSelected> cart) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .update({'cart': cart});
  // }
}
