import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class DeleteImageUsecase {
  final RestaurantReporisatory restaurantReporisatory;

  DeleteImageUsecase(this.restaurantReporisatory);

  Future<void> call(
    String resturantName,
    String imageKey,
  ) async {
    await restaurantReporisatory.deleteImage(resturantName, imageKey);
  }
}
