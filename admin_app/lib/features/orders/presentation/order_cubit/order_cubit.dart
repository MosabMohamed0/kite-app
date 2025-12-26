import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../orders/data/repositories/firebase_order_repository.dart';
import '../../../orders/domain/models/my_order_model.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final FirebaseOrderRepository _repository;

  OrderCubit(this._repository) : super(OrderState.initial()) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      emit(state.copyWith(status: OrderListStatus.loading));
      final orders = await _repository.getOrders();
      emit(state.copyWith(status: OrderListStatus.success, orders: orders));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _repository.updateOrderStatus(orderId, newStatus);
      fetchOrders();
    } catch (e) {
      // Handle
    }
  }

  void filterOrdersByStatus(OrderStatus status) {
    if (state.selectedFilter == status) {
      emit(state.copyWith(selectedFilter: null));
    } else {
      emit(state.copyWith(selectedFilter: status));
    }
  }
}
