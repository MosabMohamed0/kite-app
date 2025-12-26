part of 'product_cubit.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final String? errorMessage;

  const ProductState({
    required this.status,
    required this.products,
    this.errorMessage,
  });

  factory ProductState.initial() {
    return const ProductState(status: ProductStatus.initial, products: []);
  }

  @override
  List<Object?> get props => [status, products, errorMessage];

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
