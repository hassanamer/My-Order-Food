import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_add_order_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_delete_order_useCase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_all_orders_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_user_orders_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_update_order_usecase.dart';
import 'package:order/features/orders/presentation/cubit/order_state.dart';
import 'package:order/injection_container.dart';

class OrderCubit extends Cubit<OrderState> {
  late AddOrderUsecase addOrderUsecase;
  late DeleteOrderUsecase deleteOrderUsecase;
  late UpdateOrderUsecase updateOrderUsecase;
  late GetAllOrderUsecase getAllOrderUsecase;
  late GetUserUsecase getUserOrderUsecase;

  OrderCubit() : super(OrderStateInt());

  Future<void> getAllOrders() async {
    try {
      emit(OrderLoadingState());
      getAllOrderUsecase = sl();
      final List<OrderEntity> allOrders = await getAllOrderUsecase.call();
      emit(OrderLoadedState(orderEntity: allOrders));
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> addOrder(OrderEntity orderEntity) async {
    try {
      emit(OrderLoadingState());
      addOrderUsecase = sl();
      getUserOrderUsecase = sl();
      final BaseResponse addedOrder = await addOrderUsecase.call(orderEntity);
      if (addedOrder.status) {
        final List<OrderEntity> allData = await getAllOrderUsecase.call();

        emit(OrderSuccessState(addedOrder));
        emit(OrderLoadedState(orderEntity: allData));
      } else {
        emit(OrderErrorState(errorMessage: addedOrder.message));
      }
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> updateOrder(OrderEntity orderEntity) async {
    try {
      emit(OrderLoadingState());
      updateOrderUsecase = sl();
      final BaseResponse updatedOrder =
          await updateOrderUsecase.call(orderEntity);
      if (updatedOrder.status) {
        emit(OrderSuccessState(updatedOrder));
      } else {
        emit(OrderErrorState(errorMessage: updatedOrder.message));
      }
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> addOrUpdateItem(OrderEntity createOrderEntity, String itemName,
      int quantity, String userId) async {
    try {
      createOrderEntity.items ??= <OrderItem>[];

      int index = createOrderEntity.items!
          .indexWhere((OrderItem item) => item.itemName == itemName);
      if (index != -1) {
        createOrderEntity.items![index].quantity += quantity;
      } else {
        createOrderEntity.items!.add(
            OrderItem(userId: userId, itemName: itemName, quantity: quantity));
      }

      await updateOrder(createOrderEntity);
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> removeItem(
      OrderEntity createOrderEntity, String itemName) async {
    try {
      createOrderEntity.items ??= <OrderItem>[];
      createOrderEntity.items!
          .removeWhere((OrderItem item) => item.itemName == itemName);

      await updateOrder(createOrderEntity);
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }

  Stream<List<OrderEntity>> getOrdersStream() {
    return FirebaseFirestore.instance.collection('Order').snapshots().map(
        (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                OrderEntity.fromMap(doc.data()))
            .toList());
  }

  Stream<OrderEntity> getOrderStream(String orderId) {
    return FirebaseFirestore.instance
        .collection('Order')
        .doc(orderId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
            OrderEntity.fromMap(doc.data()!));
  }

  Future<void> deleteOrderById(String orderId) async {
    try {
      emit(OrderLoadingState());
      deleteOrderUsecase = sl();
      final BaseResponse deletedOrder = await deleteOrderUsecase.call(orderId);
      if (deletedOrder.status) {
        emit(OrderDeletedSuccessState(deletedOrder));
      } else {
        emit(OrderErrorState(errorMessage: deletedOrder.message));
      }
    } catch (e) {
      emit(OrderErrorState(errorMessage: e.toString()));
    }
  }
}
