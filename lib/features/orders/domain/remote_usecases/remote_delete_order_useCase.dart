import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/reporisatory/order_repository.dart';

class DeleteOrderUsecase {
  final OrderRepository orderReporisatory;

  DeleteOrderUsecase(this.orderReporisatory);

  Future<BaseResponse> call(String orderId) async {
    return await orderReporisatory.remoteDeleteOrders(orderId);
  }
}
