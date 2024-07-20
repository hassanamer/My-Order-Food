import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class GetAllOrderUsecase {
  final OrderRepository orderRepository;

  GetAllOrderUsecase(this.orderRepository);

  Future<List<OrderEntity>> call() async {
    return await orderRepository.remoteGetAllOrders();
  }
}
