import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/reporisatory/order_repository.dart';

class AddOrderUsecase {
  final OrderRepository orderRepository;

  AddOrderUsecase(this.orderRepository);

  Future<BaseResponse> call(OrderEntity orderEntity) async {
    return await orderRepository.remoteAddOrders(orderEntity);
  }

  Future<BaseResponse> update(OrderEntity orderEntity) async {
    return await orderRepository.remoteUpdateOrder(orderEntity);
  }

  Future<BaseResponse> updateOrderStatus(
      String orderId, OrderStatusEnum newStatus) async {
    return await orderRepository.remoteUpdateOrderStatus(orderId, newStatus);
  }

  Future<OrderEntity> remoteGetOrder(String orderId) async {
    return await orderRepository.remoteGetOrder(orderId);
  }
}
