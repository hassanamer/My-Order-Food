import 'package:order/features/event/domain/entities/event_entities.dart';

import '../reporisatory/cart_reporisatory.dart';

class ClearCartItemsUsecase {
  final CartReporisatoryInterface cartReporisatoryInterface;
  ClearCartItemsUsecase(this.cartReporisatoryInterface);

  Future<BaseResponse> call() async {
    return await cartReporisatoryInterface.clearCartItems();
  }
}
