import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

class GetUserOrderUsecase {
  final OrderRepository orderRepository;

  GetUserOrderUsecase(this.orderRepository);

  Future<RegisterAccountModel> call(String userId) async {
    return await orderRepository.remoteGetUser(userId);
  }
}
