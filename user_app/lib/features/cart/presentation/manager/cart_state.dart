import 'package:equatable/equatable.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

class CartState extends Equatable {
  final List<ProductSelected> products;
  final double totalPrice;
  final bool isLoading;

  const CartState({
    required this.products,
    required this.totalPrice,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [products, totalPrice, isLoading];
}
