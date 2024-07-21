import 'package:order/features/event/domain/reporisatory/order_repository.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

class GetUserUsecase {
  final OrderRepository orderRepository;

  GetUserUsecase(this.orderRepository);

  Future<RegisterAccountModel> call(String userId) async {
    return await orderRepository.remoteGetUser(userId);
  }

  Future<Map<String, RegisterAccountModel>> getUsers(
      List<String> userIdList) async {
    Map<String, RegisterAccountModel> userMap = {};

    List<Future<void>> futures = [];

    for (var userId in userIdList) {
      futures.add(call(userId).then((user) {
        userMap[userId] = user;
      }));
    }

    await Future.wait(futures);

    return userMap;
  }
}
