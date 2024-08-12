import 'package:order/features/cart/domain/reporisatory/cart_reporisatory.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

class ClearCartItemsUsecase {
  final CartReporisatoryInterface cartReporisatoryInterface;

  ClearCartItemsUsecase(this.cartReporisatoryInterface);

  Future<BaseResponse> call() async {
    return await cartReporisatoryInterface.clearCartItems();
  }
}
