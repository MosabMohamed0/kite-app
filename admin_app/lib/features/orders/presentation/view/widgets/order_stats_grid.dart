import 'package:admin_app/core/theme/app_colors.dart';
import 'package:admin_app/features/orders/domain/models/my_order_model.dart';
import 'package:admin_app/features/orders/presentation/order_cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrderStatsGrid extends StatelessWidget {
  final Map<OrderStatus, int> counts;
  const OrderStatsGrid({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.watch<OrderCubit>().state.selectedFilter;
    final size = MediaQuery.sizeOf(context);

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: size.width * 0.02,
      mainAxisSpacing: size.width * 0.02,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          context: context,
          title: 'Pending',
          count: counts[OrderStatus.pending] ?? 0,
          icon: Iconsax.clock_copy,
          iconColor: AppColors.pendingFG,
          iconBgColor: AppColors.pendingBG,
          status: OrderStatus.pending,
          isActive: activeFilter == OrderStatus.pending,
          size: size,
        ),
        _buildStatCard(
          context: context,
          title: 'Processing',
          count: counts[OrderStatus.processing] ?? 0,
          icon: Iconsax.box_time_copy,
          iconColor: AppColors.processingFG,
          iconBgColor: AppColors.processingBG,
          status: OrderStatus.processing,
          isActive: activeFilter == OrderStatus.processing,
          size: size,
        ),
        _buildStatCard(
          context: context,
          title: 'Shipped',
          count: counts[OrderStatus.shipped] ?? 0,
          icon: Iconsax.truck_fast_copy,
          iconColor: AppColors.processingFG,
          iconBgColor: AppColors.processingBG,
          status: OrderStatus.shipped,
          isActive: activeFilter == OrderStatus.shipped,
          size: size,
        ),
        _buildStatCard(
          context: context,
          title: 'Delivered',
          count: counts[OrderStatus.delivered] ?? 0,
          icon: Iconsax.task_square_copy,
          iconColor: AppColors.completedFG,
          iconBgColor: AppColors.completedBG,
          status: OrderStatus.delivered,
          isActive: activeFilter == OrderStatus.delivered,
          size: size,
        ),
        _buildStatCard(
          context: context,
          title: 'Cancelled',
          count: counts[OrderStatus.canceled] ?? 0,
          icon: Iconsax.close_square_copy,
          iconColor: AppColors.cancelledFG,
          iconBgColor: AppColors.cancelledBG,
          status: OrderStatus.canceled,
          isActive: activeFilter == OrderStatus.canceled,
          size: size,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required OrderStatus status,
    required bool isActive,
    required Size size,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<OrderCubit>();

    return Card(
      shape:
          isActive
              ? RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              )
              : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          cubit.filterOrdersByStatus(status);
        },
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.09,
                height: size.width * 0.09,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: size.width * 0.045),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                count.toString(),
                style: textTheme.titleMedium?.copyWith(
                  fontSize: size.width * 0.04,
                ),
              ),
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: size.width * 0.028,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
