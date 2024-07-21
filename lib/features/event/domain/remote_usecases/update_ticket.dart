import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/order_repository.dart';

class UpdateOrderUsecase {
  final OrderRepository ticketReporisatory;

  UpdateOrderUsecase(this.ticketReporisatory);

  Future<BaseResponse> call(OrderEntity eventEntity) async {
    return await ticketReporisatory.remoteUpdateOrder(eventEntity);
  }
}
