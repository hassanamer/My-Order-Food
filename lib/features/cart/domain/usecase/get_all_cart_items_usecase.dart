import 'package:order/features/cart/domain/reporisatory/cart_reporisatory.dart';
import 'package:order/features/restaurant/data/model/menu_model.dart';

class GetAllCartItemsUsecase {
  final CartReporisatoryInterface cartReporisatoryInterface;

  GetAllCartItemsUsecase(this.cartReporisatoryInterface);

  Future<List<MenuModel>> call() async {
    return await cartReporisatoryInterface.getAllCartItems();
  }
}
