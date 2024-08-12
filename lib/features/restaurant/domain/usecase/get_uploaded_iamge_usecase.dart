import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class GetUploadedImageUsecase {
  final RestaurantReporisatory restaurantReporisatory;

  GetUploadedImageUsecase(this.restaurantReporisatory);

  Future<BaseResponse> call() async {
    return await restaurantReporisatory.getUploadedImage();
  }
}
