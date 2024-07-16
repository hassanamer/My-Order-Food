import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class UpdateOrderUsecase {
  final OrderRepository ticketReporisatory;

  UpdateOrderUsecase(this.ticketReporisatory);

  Future<BaseResponse> call(CreateOrderEntity eventEntity) async {
    return await ticketReporisatory.remoteUpdateOrders(eventEntity);
  }
}
