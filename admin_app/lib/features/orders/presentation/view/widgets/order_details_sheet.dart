import 'package:admin_app/features/orders/domain/models/my_order_model.dart';
import 'package:admin_app/features/orders/presentation/view/widgets/order_status_badge.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class OrderDetailsSheet extends StatelessWidget {
  final MyOrder order;
  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'EGP ',
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.04,
                  size.height * 0.015,
                  size.width * 0.02,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Order Details: ${order.id}',
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: size.width * 0.045,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Iconsax.close_circle_copy,
                        size: size.width * 0.06,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(size.width * 0.04),
                  children: [
                    _buildOrderSummaryCard(context, size),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Customer Information',
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      padding: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context,
                            'Name:',
                            order.customerName,
                            size,
                          ),
                          _buildDetailRow(
                            context,
                            'Phone:',
                            order.customerPhone,
                            size,
                            isLtr: true,
                          ),
                          _buildDetailRow(
                            context,
                            'Address:',
                            order.customerAddress,
                            size,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Order Items',
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),

                    ...order.products.map((item) {
                      final details = item.productDetails.entries
                          .map((e) => '${e.key}: ${e.value}')
                          .join(', ');

                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.03,
                        ),
                        margin: EdgeInsets.only(bottom: size.height * 0.01),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: item.photoURL,
                                width: size.width * 0.12,
                                height: size.width * 0.12,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      width: size.width * 0.12,
                                      height: size.width * 0.12,
                                      color: Colors.grey.shade200,
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      width: size.width * 0.12,
                                      height: size.width * 0.12,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Iconsax.gallery_slash),
                                    ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.038,
                                    ),
                                  ),
                                  Text(
                                    details,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: size.width * 0.03,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              currencyFormatter.format(item.price),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    Divider(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: size.width * 0.045,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(order.totalPrice),
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status:',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: size.width * 0.032),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          _buildDetailRow(
            context,
            'Payment Method:',
            order.paymentMethod.name,
            size,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    Size size, {
    bool isLtr = false,
    bool isLast = false,
  }) {
    String displayValue =
        (value.isEmpty || value == 'Unknown User') ? 'N/A' : value;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: size.width * 0.032),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Text(
              displayValue,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.035,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
