import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/order_repository.dart';

class DeleteOrderUsecase {
  final OrderRepository ticketReporisatory;

  DeleteOrderUsecase(this.ticketReporisatory);

  Future<BaseResponse> call() async {
    return await ticketReporisatory.remoteDeleteOrders();
  }
}
