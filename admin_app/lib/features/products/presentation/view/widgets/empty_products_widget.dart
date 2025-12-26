import 'package:admin_app/features/products/presentation/view/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EmptyProductsWidget extends StatelessWidget {
  const EmptyProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.box_search_copy,
              size: 80,
              color: textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text('No Products Found', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Start by adding new products to your store.',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Iconsax.add, size: 18),
              label: const Text('Add First Product'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const ProductFormScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
