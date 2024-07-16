import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';

import '../../data/model/menu_model.dart';

abstract class RestaurantReporisatory {
  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel);
  Future<BaseResponse> uploadImage();
  Future<BaseResponse> getUploadedImage();
  Future<BaseResponse> addMenuItems(MenuModel menuModel);
  Future<List<RestaurantModel>> getAllRestaurant();
  Future<List<MenuModel>> getAllMenu();
}
