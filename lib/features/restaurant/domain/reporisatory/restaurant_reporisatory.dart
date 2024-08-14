import 'dart:io';

import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';

abstract class RestaurantReporisatory {
  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel);

  Future<BaseResponse> updateResturantMenu(RestaurantModel restaurantModel);

  Future<BaseResponse> uploadImage(Map<String, File>? imageFiles);

  Future<BaseResponse> getUploadedImage();

  Future<BaseResponse> deleteImage(String restaurantName, String imageKey);

  Future<List<RestaurantModel>> getAllRestaurant();
}
