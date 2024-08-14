import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/datasource/restaurant_datasource.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';
import 'package:order/features/restaurant/domain/usecase/add_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/delete_image_usecase.dart';
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
      RestaurantModel restaurantModel, Map<String, File>? imageFiles) async {
    try {
      emit(RestaurantLoading());
      addRestaurantUsecase = sl();
      uploadImageUsecase = sl();

      Map<String, String> imageDownloadUrls = <String, String>{};

      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (MapEntry<String, File> entry in imageFiles.entries) {
          final BaseResponse imageResponse = await uploadImageUsecase
              .call(<String, File>{entry.key: entry.value});
          if (imageResponse.status) {
            imageDownloadUrls[entry.key] = imageResponse.message;
          } else {
            emit(RestaurantError(errorMessage: imageResponse.message));
            return;
          }
        }
      }

      restaurantModel.imageURLs = imageDownloadUrls;

      final BaseResponse addedRestaurant =
          await addRestaurantUsecase.call(restaurantModel);
      if (addedRestaurant.status) {
        emit(RestaurantSuccess(addedRestaurant));
      } else {
        emit(RestaurantError(errorMessage: addedRestaurant.message));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Stream<Map<String, String>> menuImagesStream(String restaurantName) {
    return FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(restaurantName)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return Map<String, String>.from(snapshot.data()!['imageURLs']);
      } else {
        return {};
      }
    });
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

  Future<void> deleteMenuImage(String restaurantName, String imageKey) async {
    try {
      emit(RestaurantLoading());
      final DeleteImageUsecase deleteImageUsecase = sl<DeleteImageUsecase>();
      await deleteImageUsecase.call(restaurantName, imageKey);

      final RestaurantDatasourceImpl restaurantDatasource =
          RestaurantDatasourceImpl();
      final RestaurantModel? restaurantModel =
          await restaurantDatasource.getRestaurantByName(restaurantName);

      if (restaurantModel != null) {
        restaurantModel.imageURLs?.remove(imageKey);

        await restaurantDatasource.updateResturantMenu(restaurantModel);

        emit(
            MenuImageUpdatedState(restaurantModel.imageURLs!, restaurantModel));
      } else {
        emit(RestaurantError(errorMessage: 'Restaurant not found'));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> updateRestaurantMenuImage(
      String restaurantName, Map<String, File> imageFiles) async {
    try {
      emit(RestaurantLoading());
      uploadImageUsecase = sl();

      Map<String, String> imageDownloadUrls = <String, String>{};

      for (MapEntry<String, File> entry in imageFiles.entries) {
        final BaseResponse imageResponse = await uploadImageUsecase
            .call(<String, File>{entry.key: entry.value});
        if (imageResponse.status) {
          imageDownloadUrls[entry.key] = imageResponse.message;
        } else {
          emit(RestaurantError(errorMessage: imageResponse.message));
          return;
        }
      }

      final RestaurantDatasourceImpl restaurantDatasource =
          RestaurantDatasourceImpl();
      final RestaurantModel? restaurantModel =
          await restaurantDatasource.getRestaurantByName(restaurantName);
      if (restaurantModel != null) {
        restaurantModel.imageURLs = imageDownloadUrls;
        await restaurantDatasource.updateResturantMenu(restaurantModel);
        emit(RestaurantSuccess('Menu Updated Successfully'));
      } else {
        emit(RestaurantError(errorMessage: 'Restaurant not found'));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> updateMenuImage(
      String restaurantName, Map<String, File>? imageFiles) async {
    try {
      emit(RestaurantLoading());
      uploadImageUsecase = sl();
      Map<String, String> imageDownloadUrls = <String, String>{};

      for (MapEntry<String, File> entry in imageFiles!.entries) {
        final BaseResponse imageResponse = await uploadImageUsecase
            .call(<String, File>{entry.key: entry.value});
        if (imageResponse.status) {
          imageDownloadUrls[entry.key] = imageResponse.message;
        } else {
          emit(RestaurantError(errorMessage: imageResponse.message));
          return;
        }
      }

      final RestaurantDatasourceImpl restaurantDatasource =
          RestaurantDatasourceImpl();
      final RestaurantModel? restaurantModel =
          await restaurantDatasource.getRestaurantByName(restaurantName);

      if (restaurantModel != null) {
        Map<String, String> updatedImageUrls =
            restaurantModel.imageURLs ?? <String, String>{};
        updatedImageUrls.addAll(imageDownloadUrls);

        restaurantModel.imageURLs = updatedImageUrls;

        await restaurantDatasource.updateResturantMenu(restaurantModel);

        emit(MenuImageUpdatedState(updatedImageUrls, restaurantModel));
      } else {
        emit(RestaurantError(errorMessage: 'Restaurant not found'));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }
}
