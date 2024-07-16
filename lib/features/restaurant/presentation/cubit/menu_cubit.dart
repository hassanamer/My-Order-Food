import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/restaurant/domain/usecase/get_all_menu.dart';
import 'package:order/features/restaurant/presentation/cubit/menu_state.dart';
import 'package:order/injection_container.dart';

class MenuCubit extends Cubit<MenuState> {
  late GetAllMenuUsecase getAllMenuUsecase;
  MenuCubit() : super(MenuStateInt());

  Future<void> getAllMenu() async {
    try {
      emit(MenuLoading());
      getAllMenuUsecase = sl();
      final allMenu = await getAllMenuUsecase.call();
      emit(MenuLoaded(menuModel: allMenu));
    } catch (e) {
      emit(MenuError(errorMessage: e.toString()));
    }
  }
}
