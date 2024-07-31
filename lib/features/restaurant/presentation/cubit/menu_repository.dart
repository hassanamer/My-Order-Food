import '../../data/model/menu_model.dart';

abstract class MenuRepository {
  Future<void> updateMenu(MenuModel menuModel);
}
