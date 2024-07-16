import 'package:order/features/register/domain/entities/register_entities.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';

abstract class RestaurantState {}

class RestaurantStateInt extends RestaurantState {}

class RestaurantSuccess extends RestaurantState {
  RestaurantSuccess(addedRestaurant);
}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoadedState extends RestaurantState {
  final List<RestaurantModel> restaurantModel;
  RestaurantLoadedState({
    required this.restaurantModel,
  });
}

class ImageLoadedState extends RestaurantState {}

class RestaurantError extends RestaurantState {
  String errorMessage;
  RestaurantError({required this.errorMessage});
}

class CreateRestaurantSuccessfully extends RestaurantState {
  RegisterAccountEntity registerAccountEntity;
  String message = "Addedd Suessfully";
  CreateRestaurantSuccessfully(
      {required this.registerAccountEntity, required this.message});
}

class ImageSuccessState extends RestaurantState {
  ImageSuccessState(imageAdded);
}

class MenuSuccessState extends RestaurantState {
  MenuSuccessState(menuAdded);
}
