import 'package:admin_app/features/products/presentation/product_cubit/product_cubit.dart';
import 'package:admin_app/features/products/presentation/view/widgets/empty_products_widget.dart';
import 'package:admin_app/features/products/presentation/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProductStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          if (state.status == ProductStatus.success && state.products.isEmpty) {
            return const EmptyProductsWidget();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ProductCubit>().fetchProducts(),
            child: ListView.builder(
              padding: EdgeInsets.all(size.width * 0.04),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.015),
                  child: ProductCard(product: product),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const ProductFormScreen()),
          );
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
