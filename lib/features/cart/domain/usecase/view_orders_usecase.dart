import 'package:order/features/cart/domain/reporisatory/cart_reporisatory.dart';

import '../../../restaurant/data/model/menu_model.dart';

class ViewOrderUsecase {
  final CartReporisatoryInterface cartReporisatoryInterface;
  ViewOrderUsecase(this.cartReporisatoryInterface);

  Future<List<MenuModel>> call() async {
    return await cartReporisatoryInterface.viewOrders();
  }
}
