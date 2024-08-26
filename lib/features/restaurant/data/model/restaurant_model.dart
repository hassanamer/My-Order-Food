// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  String restaurantName;
  String restaurantDescription;
  String hotlineNum;
  Map<String, String>? imageURLs = {};
  String createdBy;

  RestaurantModel(
      {required this.restaurantName,
      required this.hotlineNum,
      required this.restaurantDescription,
      this.imageURLs,
      required this.createdBy});

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'hotlineNum': hotlineNum,
      'restaurantDescription': restaurantDescription,
      'imageURLs': imageURLs,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      restaurantName: map['restaurantName'],
      createdBy: map['createdBy'],
      hotlineNum: map['hotlineNum'],
      restaurantDescription: map['restaurantDescription'],
      imageURLs: (map['imageURLs'] as Map<String, dynamic>)
          .map((String key, value) => MapEntry(key, value)),
    );
  }

  factory RestaurantModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return RestaurantModel(
      restaurantName: documentSnapshot.data()!['restaurantName'],
      createdBy: documentSnapshot.data()!['createdBy'],
      restaurantDescription: documentSnapshot.data()!['restaurantDescription'],
      hotlineNum: documentSnapshot.data()!['restaurantHotline'],
      imageURLs: (documentSnapshot.data()!['imageURLs'] as Map<String, dynamic>)
          .map((String key, value) => MapEntry(key, value)),
    );
  }
}
