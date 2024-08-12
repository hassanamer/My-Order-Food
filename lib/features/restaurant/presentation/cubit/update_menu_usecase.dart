import 'package:order/features/restaurant/data/model/menu_model.dart';
import 'package:order/features/restaurant/presentation/cubit/menu_repository.dart';

class UpdateMenuUsecase {
  final MenuRepository repository;

  UpdateMenuUsecase(this.repository);

  Future<void> call(MenuModel menuModel) async {
    return await repository.updateMenu(menuModel);
  }
}
