import 'dart:io';

import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/datasource/restaurant_datasource.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class RestaurantReporisatoryImpl implements RestaurantReporisatory {
  final RestaurantDatasourceInterface restaurantDatasourceInterface;

  RestaurantReporisatoryImpl(this.restaurantDatasourceInterface);

  @override
  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel) async {
    return await restaurantDatasourceInterface.addRestaurant(restaurantModel);
  }

  @override
  Future<BaseResponse> uploadImage(File imageFile) async {
    return await restaurantDatasourceInterface.uploadImage(imageFile);
  }

  @override
  Future<BaseResponse> updateResturantMenu(
      RestaurantModel restaurantModel) async {
    return await restaurantDatasourceInterface
        .updateResturantMenu(restaurantModel);
  }

  @override
  Future<List<RestaurantModel>> getAllRestaurant() async {
    return await restaurantDatasourceInterface.getAllRestaurant();
  }

  @override
  Future<BaseResponse> getUploadedImage() async {
    return await restaurantDatasourceInterface.getUploadedImage();
  }
}
