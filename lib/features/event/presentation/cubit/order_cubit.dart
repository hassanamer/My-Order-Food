import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/remote_usecases/add_order_usecase.dart';
import 'package:order/features/event/domain/remote_usecases/delete_ticket.dart';
import 'package:order/features/event/domain/remote_usecases/remote_get_all_ticket.dart';
import 'package:order/features/event/domain/remote_usecases/update_ticket.dart';
import 'package:order/features/event/presentation/cubit/order_state.dart';
import 'package:order/injection_container.dart';

import '../../domain/remote_usecases/remote_get_user_order.dart';

class OrderCubit extends Cubit<OrderState> {
  late AddOrderUsecase addOrderUsecase;
  late DeleteOrderUsecase deleteOrderUsecase;
  late UpdateOrderUsecase updateOrderUsecase;
  late GetAllOrderUsecase getAllOrderUsecase;
  late GetUserOrderUsecase getUserOrderUsecase;

  OrderCubit() : super(OrderStateInt());

  Future<void> getAllOrders() async {
    try {
      emit(OrderLoadingState());
      getAllOrderUsecase = sl();
      final allOrders = await getAllOrderUsecase.call();
      emit(OrderLoadedState(eventEntity: allOrders));
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> addOrder(CreateOrderEntity eventEntity) async {
    try {
      emit(OrderLoadingState());
      addOrderUsecase = sl();
      final allData = await getAllOrderUsecase.call();
      final addedOrder = await addOrderUsecase.call(eventEntity);
      final getUserOrder = await getUserOrderUsecase.call();
      if (addedOrder.status) {
        emit(OrderSuccessState(getUserOrder));
        emit(OrderLoadedState(eventEntity: allData));
      } else {
        emit(OrderErrorState(errorMessage: addedOrder.message));
      }
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> updateOrder(CreateOrderEntity eventEntity) async {
    try {
      emit(OrderLoadingState());
      updateOrderUsecase = sl();
      final updatedOrder = await updateOrderUsecase.call(eventEntity);
      if (updatedOrder.status) {
        emit(OrderSuccessState(updatedOrder));
      } else {
        emit(OrderErrorState(errorMessage: updatedOrder.message));
      }
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> deleteOrder() async {
    try {
      emit(OrderLoadingState());
      deleteOrderUsecase = sl();
      final deletedOrder = await deleteOrderUsecase.call();
      if (deletedOrder.status) {
        emit(OrderDeletedSuccessState(deletedOrder));
      } else {
        emit(OrderErrorState(errorMessage: deletedOrder.message));
      }
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> addOrUpdateItem(CreateOrderEntity createOrderEntity,
      String itemName, int quantity, String userId) async {
    try {
      // Ensure items map is initialized
      createOrderEntity.items ??= [];

      // Update item quantity
      // if (createOrderEntity.items!.containsKey(itemName)) {
      //   createOrderEntity.items![itemName] = quantity;
      // } else {
      //   // Add new item with quantity
      //   createOrderEntity.items![itemName] = quantity;
      // }
      createOrderEntity.items!.add(
          OrderItem(userId: userId, itemName: itemName, quantity: quantity));

      // Call update ticket function to persist changes
      await updateOrder(createOrderEntity);
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> removeItem(
      CreateOrderEntity createOrderEntity, String itemName) async {
    try {
      // Ensure items map is initialized
      createOrderEntity.items ??= [];

      // Remove item from items map
      createOrderEntity.items!.removeWhere((item) => item.itemName == itemName);

      // Call update ticket function to persist changes
      await updateOrder(createOrderEntity);
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }
}
