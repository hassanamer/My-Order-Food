import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/cart/domain/usecase/add_items_to_cart_usecase.dart';
import 'package:order/features/cart/domain/usecase/clear_cart_items_usecase.dart';
import 'package:order/features/cart/domain/usecase/get_all_cart_items_usecase.dart';
import 'package:order/features/cart/domain/usecase/view_orders_usecase.dart';
import 'package:order/features/cart/presentation/cubit/cart_state.dart';
import 'package:order/injection_container.dart';

import '../../../restaurant/data/model/menu_model.dart';

class CartCubit extends Cubit<CartState> {
  late AddProductToCartUsecase addProductToCartUsecase;
  late GetAllCartItemsUsecase getAllCartItemsUsecase;
  late ViewOrderUsecase viewOrderUsecase;
  late ClearCartItemsUsecase clearCartItemsUsecase;

  CartCubit() : super(CartLoading());

  Future<void> addProductToCart(MenuModel menuModel) async {
    try {
      addProductToCartUsecase = sl();
      final addedCartItem = await addProductToCartUsecase.call(menuModel);
      if (addedCartItem.status) {
        emit(CartSuccess(addedCartItem));
      } else {
        emit(CartError(errorMessage: addedCartItem.message));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> getAllCartItems() async {
    try {
      emit(CartLoading());
      getAllCartItemsUsecase = sl();
      final allCartItems = await getAllCartItemsUsecase.call();
      if (allCartItems.isEmpty) {
        emit(EmptyCart());
      } else {
        emit(CartItemsLoadded(menuModel: allCartItems));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> viewOrder() async {
    try {
      emit(CartLoading());
      viewOrderUsecase = sl();
      final getAllOrders = await viewOrderUsecase.call();
      emit(CartItemsLoadded(menuModel: getAllOrders));
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> clearCartItems() async {
    try {
      emit(CartLoading());
      clearCartItemsUsecase = sl();
      final clearedCart = await clearCartItemsUsecase.call();
      if (clearedCart.status) {
        emit(CartClearedSuccessfully(clearedCart));
      } else {
        emit(CartError(errorMessage: clearedCart.message));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }
}
