import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/domain/reporisatory/order_repository.dart';

class DeleteOrderUsecase {
  final OrderRepository ticketReporisatory;

  DeleteOrderUsecase(this.ticketReporisatory);

  Future<BaseResponse> call() async {
    return await ticketReporisatory.remoteDeleteOrders();
  }
}
