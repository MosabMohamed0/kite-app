part of 'order_cubit.dart';

enum OrderListStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  final OrderListStatus status;
  final List<MyOrder> orders;
  final String? errorMessage;
  final OrderStatus? selectedFilter;
  const OrderState({
    required this.status,
    required this.orders,
    this.errorMessage,
    this.selectedFilter,
  });

  factory OrderState.initial() {
    return const OrderState(status: OrderListStatus.initial, orders: []);
  }

  Map<OrderStatus, int> get statusCounts {
    final counts = {for (var status in OrderStatus.values) status: 0};
    for (var order in orders) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }
    return counts;
  }

  List<MyOrder> get filteredOrders {
    if (selectedFilter == null) {
      return orders;
    } else {
      return orders.where((order) => order.status == selectedFilter).toList();
    }
  }

  @override
  List<Object?> get props => [status, orders, errorMessage, selectedFilter];

  OrderState copyWith({
    OrderListStatus? status,
    List<MyOrder>? orders,
    String? errorMessage,
    OrderStatus? selectedFilter,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter,
    );
  }
}
