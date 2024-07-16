import 'package:order/features/cart/domain/reporisatory/cart_reporisatory.dart';

import '../../../restaurant/data/model/menu_model.dart';

class GetAllCartItemsUsecase {
  final CartReporisatoryInterface cartReporisatoryInterface;
  GetAllCartItemsUsecase(this.cartReporisatoryInterface);

  Future<List<MenuModel>> call() async {
    return await cartReporisatoryInterface.getAllCartItems();
  }
}
