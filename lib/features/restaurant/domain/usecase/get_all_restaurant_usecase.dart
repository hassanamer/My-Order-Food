import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

class GetAllRestaurantUsecase {
  final RestaurantReporisatory restaurantReporisatory;
  GetAllRestaurantUsecase(this.restaurantReporisatory);

  Future<List<RestaurantModel>> call() async {
    return await restaurantReporisatory.getAllRestaurant();
  }
}
