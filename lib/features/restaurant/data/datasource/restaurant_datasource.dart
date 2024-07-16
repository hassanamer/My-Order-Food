import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';

import '../../../../core/services/awesome_notification_service.dart';
import '../model/menu_model.dart';

class FirebaseDatasourceProvider {
  static final _firebaseDatasourceProvider =
      FirebaseDatasourceProvider._internal();

  factory FirebaseDatasourceProvider() {
    return _firebaseDatasourceProvider;
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ImagePicker imagePicker = ImagePicker();

  FirebaseDatasourceProvider._internal();
}

abstract class RestaurantDatasourceInterface
    extends FirebaseDatasourceProvider {
  RestaurantDatasourceInterface() : super._internal();

  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel);
  Future<BaseResponse> uploadImage();
  Future<BaseResponse> getUploadedImage();
  Future<BaseResponse> addMenuItems(MenuModel menuModel);
  Future<List<RestaurantModel>> getAllRestaurant();
  Future<List<MenuModel>> getAllMenu();
}

class RestaurantDatasourceImpl extends RestaurantDatasourceInterface {
  RestaurantDatasourceImpl() : super();

  @override
  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel) async {
    try {
      await firebaseFirestore.collection('Restaurants').doc().set({
        "restaurantName": restaurantModel.restaurantName,
        "restaurantDescription": restaurantModel.restaurantDescription,
        "restaurantHotline": restaurantModel.hotlineNum,
      });
      await AwesomeNotificationService.showNotification(
          title: "Restaurant added ${restaurantModel.restaurantName}",
          body: restaurantModel.restaurantDescription);
      return BaseResponse(status: true, message: 'added Successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> uploadImage() async {
    try {
      //Select Image
      XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      var file = File(pickedImage!.path);

      //Upload to Firebase
      var snapshot =
          await firebaseStorage.ref().child('images/$file').putFile(file);

      await snapshot.ref.getDownloadURL();

      return BaseResponse(status: true, message: "Image added successfuly");
    } catch (e) {
      return BaseResponse(
          status: false, message: "You must choose an image..!");
    }
  }

  @override
  Future<BaseResponse> addMenuItems(MenuModel menuModel) async {
    try {
      await firebaseFirestore.collection('Menus').doc().set({
        "name": menuModel.name,
        "description": menuModel.description,
        "price": menuModel.price,
      });

      return BaseResponse(status: true, message: "Successfully added");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<List<RestaurantModel>> getAllRestaurant() async {
    final retrive = firebaseFirestore.collection('Restaurants');
    final querySnapshot = await retrive.get();
    querySnapshot.docs.map((e) => e.data()).toList();
    List<RestaurantModel> restaurants = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      restaurants.add(RestaurantModel.fromSnapShot(doc));
    }
    return restaurants;
  }

  @override
  Future<List<MenuModel>> getAllMenu() async {
    final retrive = firebaseFirestore.collection('Menus');
    final querySnapshot = await retrive.get();
    querySnapshot.docs.map((e) => e.data()).toList();
    List<MenuModel> menus = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      menus.add(MenuModel.fromSnapShot(doc));
    }
    return menus;
  }

  @override
  Future<BaseResponse> getUploadedImage() async {
    try {
      XFile? pickedImage;
      var file = File(pickedImage!.path);
      var snapshot =
          await firebaseStorage.ref().child('images/$file').putFile(file);
      await snapshot.ref.getDownloadURL();

      return BaseResponse(status: true, message: "Image retrive successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }
}
