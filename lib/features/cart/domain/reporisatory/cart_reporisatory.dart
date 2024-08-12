import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/model/menu_model.dart';

abstract class CartReporisatoryInterface {
  Future<BaseResponse> addProductToCart(MenuModel menuModel);

  Future<List<MenuModel>> getAllCartItems();

  Future<List<MenuModel>> viewOrders();

  Future<BaseResponse> clearCartItems();
}
