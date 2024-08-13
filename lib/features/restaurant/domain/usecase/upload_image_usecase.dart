import 'dart:io';

import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class UploadImageUsecase {
  final RestaurantReporisatory restaurantReporisatory;

  UploadImageUsecase(this.restaurantReporisatory);

  Future<BaseResponse> call(File imageFile) async {
    return await restaurantReporisatory.uploadImage(imageFile);
  }
}
