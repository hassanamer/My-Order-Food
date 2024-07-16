import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';

import '../../data/model/menu_model.dart';

class GetAllMenuUsecase {
  final RestaurantReporisatory restaurantReporisatory;
  GetAllMenuUsecase(this.restaurantReporisatory);

  Future<List<MenuModel>> call() async {
    return await restaurantReporisatory.getAllMenu();
  }
}
