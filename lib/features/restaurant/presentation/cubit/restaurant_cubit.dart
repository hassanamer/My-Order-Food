import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/datasource/restaurant_datasource.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/domain/usecase/add_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_all_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/upload_image_usecase.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_state.dart';
import 'package:order/injection_container.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  late AddRestaurantUsecase addRestaurantUsecase;
  late UploadImageUsecase uploadImageUsecase;
  late GetAllRestaurantUsecase getAllRestaurantUsecase;

  RestaurantCubit() : super(RestaurantStateInt());

  Future<void> addRestaurant(
      RestaurantModel restaurantModel, File imageFile) async {
    try {
      emit(RestaurantLoading());
      addRestaurantUsecase = sl();
      uploadImageUsecase = sl();
      // ignore: always_specify_types
      final imageResponse = await uploadImageUsecase.call(imageFile);
      if (imageResponse.status) {
        restaurantModel.imageURL =
            imageResponse.message; // Use message field for imageURL
        final BaseResponse addedRestaurant =
            await addRestaurantUsecase.call(restaurantModel);
        if (addedRestaurant.status) {
          emit(RestaurantSuccess(addedRestaurant));
        } else {
          emit(RestaurantError(errorMessage: addedRestaurant.message));
        }
      } else {
        emit(RestaurantError(errorMessage: imageResponse.message));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> getAllRestaurants() async {
    try {
      emit(RestaurantLoading());
      getAllRestaurantUsecase = sl();
      final List<RestaurantModel> allRestaurants =
          await getAllRestaurantUsecase.call();
      emit(RestaurantLoadedState(restaurantModel: allRestaurants));
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> updateRestaurantMenuImage(
      String restaurantName, File imageFile) async {
    try {
      emit(RestaurantLoading());
      uploadImageUsecase = sl();
      final BaseResponse imageResponse =
          await uploadImageUsecase.call(imageFile);
      if (imageResponse.status) {
        final RestaurantDatasourceImpl restaurantDatasource =
            RestaurantDatasourceImpl();
        final RestaurantModel? restaurantModel =
            await restaurantDatasource.getRestaurantByName(restaurantName);
        if (restaurantModel != null) {
          restaurantModel.imageURL = imageResponse.message;
          await restaurantDatasource.updateResturantMenu(restaurantModel);
          emit(RestaurantSuccess('Menu Updated Successfully'));
        } else {
          emit(RestaurantError(errorMessage: 'Restaurant not found'));
        }
      } else {
        emit(RestaurantError(errorMessage: imageResponse.message));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> updateMenuImage(String restaurantName, File imageFile) async {
    try {
      emit(RestaurantLoading());
      uploadImageUsecase = sl();
      final BaseResponse imageResponse =
          await uploadImageUsecase.call(imageFile);
      if (imageResponse.status) {
        final RestaurantDatasourceImpl restaurantDatasource =
            RestaurantDatasourceImpl();
        final RestaurantModel? restaurantModel =
            await restaurantDatasource.getRestaurantByName(restaurantName);
        if (restaurantModel != null) {
          restaurantModel.imageURL = imageResponse.message;
          await restaurantDatasource.updateResturantMenu(restaurantModel);
          emit(
            MenuImageUpdatedState(imageResponse.message, restaurantModel),
          );
        } else {
          emit(RestaurantError(errorMessage: 'Restaurant not found'));
        }
      } else {
        emit(RestaurantError(errorMessage: imageResponse.message));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }
}
