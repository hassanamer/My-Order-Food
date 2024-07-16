import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class UploadImageUsecase {
  final RestaurantReporisatory restaurantReporisatory;
  UploadImageUsecase(this.restaurantReporisatory);

  Future<BaseResponse> call() async {
    return await restaurantReporisatory.uploadImage();
  }
}
