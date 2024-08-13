import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/restaurant/data/model/menu_model.dart';
import 'package:order/features/restaurant/data/model/restaurant_model.dart';

class FirebaseDatasourceProvider {
  static final FirebaseDatasourceProvider _firebaseDatasourceProvider =
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

  Future<BaseResponse> uploadImage(File imageFile);

  Future<BaseResponse> getUploadedImage();

  Future<List<RestaurantModel>> getAllRestaurant();

  Future<void> updateMenu(MenuModel menuModel); // Add update menu method
  Future<BaseResponse> updateResturantMenu(
      RestaurantModel restaurantModel); // Add update menu method
}

class RestaurantDatasourceImpl extends RestaurantDatasourceInterface {
  RestaurantDatasourceImpl() : super();

  @override
  Future<BaseResponse> addRestaurant(RestaurantModel restaurantModel) async {
    try {
      await firebaseFirestore
          .collection('Restaurants')
          .doc(restaurantModel.restaurantName)
          // ignore: always_specify_types
          .set({
        'restaurantName': restaurantModel.restaurantName,
        'restaurantDescription': restaurantModel.restaurantDescription,
        'restaurantHotline': restaurantModel.hotlineNum,
        'imageURL': restaurantModel.imageURL,
      });
      return BaseResponse(status: true, message: 'added Successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> updateResturantMenu(
      RestaurantModel restaurantModel) async {
    try {
      await firebaseFirestore
          .collection('Restaurants')
          .doc(restaurantModel.restaurantName)
          .update(restaurantModel.toMap());
      return BaseResponse(status: true, message: 'Menu Updated Successfully');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMenu(MenuModel menuModel) async {
    try {
      await firebaseFirestore
          .collection('Menus')
          .doc(menuModel.name)
          .update(menuModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> uploadImage(File imageFile) async {
    try {
      TaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child('images/${imageFile.path.split('/').last}')
          .putFile(imageFile);

      String downloadURL = await snapshot.ref.getDownloadURL();

      return BaseResponse(
          status: true, message: downloadURL); // Return the URL as the message
    } catch (e) {
      return BaseResponse(
          status: false, message: 'You must choose an image..!');
    }
  }

  @override
  Future<List<RestaurantModel>> getAllRestaurant() async {
    final CollectionReference<Map<String, dynamic>> retrieve =
        firebaseFirestore.collection('Restaurants');
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await retrieve.get();
    List<RestaurantModel> restaurants = <RestaurantModel>[];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      restaurants.add(RestaurantModel.fromSnapShot(doc));
    }
    return restaurants;
  }

  @override
  Future<BaseResponse> getUploadedImage() async {
    try {
      XFile? pickedImage;
      File file = File(pickedImage!.path);
      TaskSnapshot snapshot =
          await firebaseStorage.ref().child('images/$file').putFile(file);
      await snapshot.ref.getDownloadURL();

      return BaseResponse(status: true, message: 'Image retrive successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  Future<RestaurantModel?> getRestaurantByName(String restaurantName) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firebaseFirestore
              .collection('Restaurants')
              .doc(restaurantName)
              .get();
      if (docSnapshot.exists) {
        return RestaurantModel.fromSnapShot(docSnapshot);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
