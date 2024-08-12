import 'package:order/features/restaurant/data/model/menu_model.dart';

abstract class MenuRepository {
  Future<void> updateMenu(MenuModel menuModel);
}
