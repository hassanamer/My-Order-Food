import 'package:order/features/orders/domain/entities/order_entities.dart'
    as remote_get_all_orders;
import 'package:order/features/orders/domain/reporisatory/order_repository.dart';

class GetAllOrderUsecase {
  final OrderRepository orderRepository;

  GetAllOrderUsecase(this.orderRepository);

  Future<List<remote_get_all_orders.OrderEntity>> call() async {
    return await orderRepository.remoteGetAllOrders();
  }
}
