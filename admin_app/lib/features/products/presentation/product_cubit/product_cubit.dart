import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../products/data/repositories/firebase_product_repository.dart'; // 1. التعديل هنا
import '../../../products/domain/models/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirebaseProductRepository _repository;

  ProductCubit(this._repository) : super(ProductState.initial()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final products = await _repository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _repository.addProduct(product);
      fetchProducts();
    } catch (e) {
      // Handle
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _repository.updateProduct(product);
      fetchProducts();
    } catch (e) {
      // Handle
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final productToDelete = state.products.firstWhere((p) => p.id == id);

      await _repository.deleteProduct(productToDelete);

      fetchProducts();
    } catch (e) {
      // Handle
    }
  }
}
