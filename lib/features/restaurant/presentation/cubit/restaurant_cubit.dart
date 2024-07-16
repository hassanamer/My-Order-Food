import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/domain/usecase/add_menu_items_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/add_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_all_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_uploaded_iamge_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/upload_image_usecase.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_state.dart';
import 'package:order/injection_container.dart';

import '../../data/model/menu_model.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  late AddRestaurantUsecase addRestaurantUsecase;
  late UploadImageUsecase uploadImageUsecase;
  late AddMenuItemsUsecase addMenuItemsUsecase;
  late GetAllRestaurantUsecase getAllRestaurantUsecase;
  late GetUploadedImageUsecase getUploadedImageUsecase;

  RestaurantCubit() : super(RestaurantStateInt());

  Future<void> addRestaurant(RestaurantModel restaurantModel) async {
    try {
      emit(RestaurantLoading());
      addRestaurantUsecase = sl();
      final addedRestaurant = await addRestaurantUsecase.call(restaurantModel);
      if (addedRestaurant.status) {
        emit(RestaurantSuccess(addedRestaurant));
      } else {
        emit(RestaurantError(errorMessage: addedRestaurant.message));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> uploadImage() async {
    uploadImageUsecase = sl();
    final imageAdded = await uploadImageUsecase.call();
    if (imageAdded.status) {
      emit(ImageSuccessState(imageAdded));
    } else {
      emit(RestaurantError(errorMessage: imageAdded.message));
    }
  }

  Future<void> addMenuItems(MenuModel menuModel) async {
    try {
      addMenuItemsUsecase = sl();
      final menuAdded = await addMenuItemsUsecase.call(menuModel);
      if (menuAdded.status) {
        emit(MenuSuccessState(menuAdded));
      } else {
        emit(RestaurantError(errorMessage: menuAdded.message));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> getAllRestaurants() async {
    try {
      emit(RestaurantLoading());
      getAllRestaurantUsecase = sl();
      final allRestaurants = await getAllRestaurantUsecase.call();
      emit(RestaurantLoadedState(restaurantModel: allRestaurants));
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> getUploadedImage() async {
    try {
      emit(RestaurantLoading());
      getUploadedImageUsecase = sl();
      await getUploadedImageUsecase.call();
      emit(ImageLoadedState());
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }
}
