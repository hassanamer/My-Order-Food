import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class AddOrderUsecase {
  final OrderRepository orderRepository;

  AddOrderUsecase(this.orderRepository);

  Future<BaseResponse> call(CreateOrderEntity orderEntity) async {
    return await orderRepository.remoteAddOrders(orderEntity);
  }
}
