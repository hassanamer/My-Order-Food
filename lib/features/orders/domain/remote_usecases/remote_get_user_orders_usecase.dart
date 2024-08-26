import 'package:order/features/orders/domain/reporisatory/order_repository.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

class GetUsersUsecase {
  final OrderRepository orderRepository;

  GetUsersUsecase(this.orderRepository);

  Future<RegisterAccountModel> call(String userId) async {
    return await orderRepository.remoteGetUser(userId);
  }

  Future<Map<String, RegisterAccountModel>> getUsers(
      List<String> userIdList) async {
    Map<String, RegisterAccountModel> userMap =
        <String, RegisterAccountModel>{};

    List<Future<void>> futures = <Future<void>>[];

    for (String userId in userIdList) {
      futures.add(call(userId).then((RegisterAccountModel user) {
        userMap[userId] = user;
      }));
    }

    await Future.wait(futures);

    return userMap;
  }
}
