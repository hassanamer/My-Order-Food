import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class DeleteOrderUsecase {
  final OrderRepository ticketReporisatory;

  DeleteOrderUsecase(this.ticketReporisatory);

  Future<BaseResponse> call() async {
    return await ticketReporisatory.remoteDeleteOrders();
  }
}
