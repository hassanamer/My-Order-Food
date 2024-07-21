import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/order_repository.dart';

class AddOrderUsecase {
  final OrderRepository orderRepository;

  AddOrderUsecase(this.orderRepository);

  Future<BaseResponse> call(OrderEntity orderEntity) async {
    return await orderRepository.remoteAddOrders(orderEntity);
  }

  Future<BaseResponse> update(OrderEntity orderEntity) async {
    return await orderRepository.remoteUpdateOrder(orderEntity);
  }

  Future<OrderEntity> remoteGetOrder(String orderId) async {
    return await orderRepository.remoteGetOrder(orderId);
  }
}
