import 'package:admin_app/features/orders/presentation/order_cubit/order_cubit.dart';
import 'package:admin_app/features/orders/presentation/view/widgets/order_card.dart';
import 'package:admin_app/features/orders/presentation/view/widgets/order_stats_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.status == OrderListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == OrderListStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          final filteredList = state.filteredOrders;

          return RefreshIndicator(
            onRefresh: () => context.read<OrderCubit>().fetchOrders(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  sliver: SliverToBoxAdapter(
                    child: OrderStatsGrid(counts: state.statusCounts),
                  ),
                ),
                if (state.selectedFilter != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        size.width * 0.04,
                        0,
                        size.width * 0.04,
                        size.height * 0.015,
                      ),
                      child: ActionChip(
                        avatar: Icon(
                          Iconsax.close_circle_copy,
                          size: size.width * 0.04,
                        ),
                        label: Text(
                          'Clear Filter (Showing ${state.selectedFilter!.name} only)',
                          style: TextStyle(fontSize: size.width * 0.032),
                        ),
                        onPressed: () {
                          context.read<OrderCubit>().filterOrdersByStatus(
                            state.selectedFilter!,
                          );
                        },
                      ),
                    ),
                  ),
                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.selectedFilter != null
                            ? 'No orders found matching this status.'
                            : 'No orders found yet.',
                        style: TextStyle(fontSize: size.width * 0.04),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    size.width * 0.04,
                    0,
                    size.width * 0.04,
                    size.height * 0.02,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final order = filteredList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.015),
                        child: OrderCard(order: order),
                      );
                    }, childCount: filteredList.length),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
