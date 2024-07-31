import '../../data/model/menu_model.dart';

abstract class MenuState {}

class MenuStateInt extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuModel> menuModel;

  MenuLoaded({
    required this.menuModel,
  });
}

class MenuUpdated extends MenuState {}

class MenuError extends MenuState {
  String errorMessage;

  MenuError({required this.errorMessage});
}
