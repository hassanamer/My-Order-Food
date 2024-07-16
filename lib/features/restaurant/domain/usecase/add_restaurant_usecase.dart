import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class AddRestaurantUsecase {
  final RestaurantReporisatory restaurantReporisatory;

  AddRestaurantUsecase(this.restaurantReporisatory);

  Future<BaseResponse> call(
    RestaurantModel restaurantModel,
  ) async {
    return await restaurantReporisatory.addRestaurant(restaurantModel);
  }
}
