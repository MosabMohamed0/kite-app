import 'package:admin_app/features/orders/domain/models/my_order_model.dart';
import 'package:admin_app/features/orders/presentation/order_cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'order_status_badge.dart';
import 'order_details_sheet.dart';

class OrderCard extends StatelessWidget {
  final MyOrder order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'EGP ',
    );
    final dateFormatter = DateFormat('yyyy/MM/dd - hh:mm a');

    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => OrderDetailsSheet(order: order),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.id,
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: size.width * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              SizedBox(height: size.height * 0.005),
              Text(
                dateFormatter.format(order.date.toDate()),
                style: textTheme.bodySmall?.copyWith(
                  fontSize: size.width * 0.03,
                ),
              ),
              Divider(height: size.height * 0.025),

              _buildInfoRow(
                context,
                Iconsax.user_copy,
                'Customer:',
                order.customerName,
                size,
              ),
              _buildInfoRow(
                context,
                Iconsax.call_copy,
                'Phone:',
                order.customerPhone,
                size,
                isLtr: true,
              ),
              _buildInfoRow(
                context,
                Iconsax.location_copy,
                'Address:',
                order.customerAddress,
                size,
              ),
              _buildInfoRow(
                context,
                Iconsax.money_recive_copy,
                'Total:',
                currencyFormatter.format(order.totalPrice),
                size,
                isPrimary: true,
              ),

              SizedBox(height: size.height * 0.015),
              _buildActionButtons(context, size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Size size, {
    bool isLtr = false,
    bool isPrimary = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.008),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: size.width * 0.035,
            color: textTheme.bodySmall?.color,
          ),
          SizedBox(width: size.width * 0.015),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(fontSize: size.width * 0.032),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: size.width * 0.035,
                color: isPrimary ? Theme.of(context).primaryColor : null,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Size size) {
    final cubit = context.read<OrderCubit>();
    List<Widget> buttons = [];

    switch (order.status) {
      case OrderStatus.pending:
        buttons.add(
          _buildButton(
            context,
            'Start Processing',
            () => cubit.updateOrderStatus(order.id, OrderStatus.processing),
            size,
            isPrimary: true,
          ),
        );
        break;
      case OrderStatus.processing:
        buttons.add(
          _buildButton(
            context,
            'Mark as Shipped',
            () => cubit.updateOrderStatus(order.id, OrderStatus.shipped),
            size,
            isPrimary: true,
          ),
        );
        break;
      case OrderStatus.shipped:
        buttons.add(
          _buildButton(
            context,
            'Mark as Delivered',
            () => cubit.updateOrderStatus(order.id, OrderStatus.delivered),
            size,
            isPrimary: true,
          ),
        );
        break;
      default:
        break;
    }

    if (order.status != OrderStatus.delivered &&
        order.status != OrderStatus.canceled) {
      if (buttons.isNotEmpty) {
        buttons.add(SizedBox(width: size.width * 0.025));
      }
      buttons.add(
        _buildButton(
          context,
          'Cancel Order',
          () => cubit.updateOrderStatus(order.id, OrderStatus.canceled),
          size,
          isPrimary: false,
        ),
      );
    }

    return Row(children: buttons);
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
    Size size, {
    bool isPrimary = true,
  }) {
    return Expanded(
      child: SizedBox(
        height: size.height * 0.05,
        child:
            isPrimary
                ? ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    label,
                    style: TextStyle(fontSize: size.width * 0.032),
                  ),
                )
                : OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: size.width * 0.032),
                  ),
                ),
      ),
    );
  }
}
