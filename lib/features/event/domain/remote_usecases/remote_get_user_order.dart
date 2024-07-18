import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

import '../../../register/data/models/register_account_model.dart';

class GetUserOrderUsecase {
  final OrderRepository orderRepository;

  GetUserOrderUsecase(this.orderRepository);

  Future<RegisterAccountModel> call() async {
    return await orderRepository.remoteGetUserOrders();
  }
}
