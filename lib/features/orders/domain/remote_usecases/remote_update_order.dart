import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/reporisatory/order_repository.dart';

class UpdateOrderUsecase {
  final OrderRepository orderReporisatory;

  UpdateOrderUsecase(this.orderReporisatory);

  Future<BaseResponse> call(OrderEntity orderEntity) async {
    return await orderReporisatory.remoteUpdateOrder(orderEntity);
  }
}
