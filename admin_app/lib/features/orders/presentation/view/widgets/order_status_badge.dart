import 'package:admin_app/core/theme/app_colors.dart';
import 'package:admin_app/features/orders/domain/models/my_order_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    String label;
    IconData icon;
    Color bgColor;
    Color fgColor;

    switch (status) {
      case OrderStatus.pending:
        label = 'Pending';
        icon = Iconsax.clock_copy;
        bgColor = isDark ? AppColors.darkPendingBG : AppColors.pendingBG;
        fgColor = isDark ? AppColors.darkPendingFG : AppColors.pendingFG;
        break;
      case OrderStatus.processing:
        label = 'Processing';
        icon = Iconsax.box_time_copy;
        bgColor = isDark ? AppColors.darkProcessingBG : AppColors.processingBG;
        fgColor = isDark ? AppColors.darkProcessingFG : AppColors.processingFG;
        break;
      case OrderStatus.shipped:
        label = 'Shipped';
        icon = Iconsax.truck_fast_copy;
        bgColor = isDark ? AppColors.darkProcessingBG : AppColors.processingBG;
        fgColor = isDark ? AppColors.darkProcessingFG : AppColors.processingFG;
        break;
      case OrderStatus.delivered:
        label = 'Delivered';
        icon = Iconsax.task_square_copy;
        bgColor = isDark ? AppColors.darkCompletedBG : AppColors.completedBG;
        fgColor = isDark ? AppColors.darkCompletedFG : AppColors.completedFG;
        break;
      case OrderStatus.canceled:
        label = 'Cancelled';
        icon = Iconsax.close_square_copy;
        bgColor = isDark ? AppColors.darkCancelledBG : AppColors.cancelledBG;
        fgColor = isDark ? AppColors.darkCancelledFG : AppColors.cancelledFG;
        break;
    }

    return Chip(
      avatar: Icon(icon, color: fgColor, size: size.width * 0.035),
      label: Text(label),
      labelStyle: TextStyle(
        color: fgColor,
        fontSize: size.width * 0.028,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: bgColor,
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
        vertical: 0,
      ),
    );
  }
}
