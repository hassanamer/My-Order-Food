import '../../../restaurant/data/model/menu_model.dart';

abstract class CartState {}

class CartStateInt extends CartState {}

class CartLoading extends CartState {}

class CartError extends CartState {
  String errorMessage;
  CartError({required this.errorMessage});
}

class CartSuccess extends CartState {
  CartSuccess(addedCartItem);
}

class CartItemsLoadded extends CartState {
  final List<MenuModel> menuModel;
  CartItemsLoadded({
    required this.menuModel,
  });
}

class CartClearedSuccessfully extends CartState {
  CartClearedSuccessfully(clearedCart);
}

class EmptyCart extends CartState {}
