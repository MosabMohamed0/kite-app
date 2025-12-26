import 'package:admin_app/core/theme/app_colors.dart';
import 'package:admin_app/features/products/domain/models/product_model.dart';
import 'package:admin_app/features/products/presentation/product_cubit/product_cubit.dart';
import 'package:admin_app/features/products/presentation/view/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'EGP ',
    );

    final int totalStock = product.totalQuantity;
    final Color stockColor =
        totalStock == 0
            ? colorScheme.error
            : (totalStock <= 20 ? AppColors.stockYellow : AppColors.stockGreen);

    final double imageSize = size.width * 0.22;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: product.photoUrl,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: imageSize,
                          height: imageSize,
                          color: Colors.grey.shade200,
                          child: const Icon(Iconsax.gallery),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: imageSize,
                          height: imageSize,
                          color: Colors.grey.shade200,
                          child: Icon(
                            Iconsax.gallery_slash,
                            color: AppColors.lightDestructive,
                            size: imageSize * 0.4,
                          ),
                        ),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontSize: size.width * 0.04,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        'Brand: ${product.brand} | Category: ${product.category}',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: size.width * 0.03,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFormatter.format(product.price),
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.038,
                            ),
                          ),
                          Text(
                            totalStock > 0
                                ? '$totalStock in stock'
                                : 'Out of stock',
                            style: textTheme.bodySmall?.copyWith(
                              color: stockColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              product.description,
              style: textTheme.bodySmall?.copyWith(
                fontSize: size.width * 0.032,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Divider(height: size.height * 0.03),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Edit',
                    Iconsax.edit_copy,
                    colorScheme.primary,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ProductFormScreen(product: product),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Delete',
                    Iconsax.trash_copy,
                    colorScheme.error,
                    () => _showDeleteDialog(context, product.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.4)),
      ),
      onPressed: onTap,
    );
  }

  void _showDeleteDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onPressed: () {
                  context.read<ProductCubit>().deleteProduct(productId);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }
}
