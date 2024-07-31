import 'dart:io';

import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';

abstract class RestaurantReporisatory {
  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel);

  Future<BaseResponse> updateResturantMenu(RestaurantModel restaurantModel);

  Future<BaseResponse> uploadImage(File imageFile);

  Future<BaseResponse> getUploadedImage();

  Future<List<RestaurantModel>> getAllRestaurant();
}
