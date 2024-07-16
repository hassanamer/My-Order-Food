import 'package:order/features/event/domain/entities/event_entities.dart';

import '../../../restaurant/data/model/menu_model.dart';

abstract class CartReporisatoryInterface {
  Future<BaseResponse> addProductToCart(MenuModel menuModel);
  Future<List<MenuModel>> getAllCartItems();
  Future<List<MenuModel>> viewOrders();
  Future<BaseResponse> clearCartItems();
}
