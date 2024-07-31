import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  String restaurantName;
  String restaurantDescription;
  String hotlineNum;
  String? imageURL;

  RestaurantModel({
    required this.restaurantName,
    required this.hotlineNum,
    required this.restaurantDescription,
    this.imageURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'hotlineNum': hotlineNum,
      'restaurantDescription': restaurantDescription,
      'imageURL': imageURL,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      restaurantName: map['restaurantName'],
      hotlineNum: map['hotlineNum'],
      restaurantDescription: map['restaurantDescription'],
      imageURL: map['imageURL'],
    );
  }

  factory RestaurantModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return RestaurantModel(
      restaurantName: documentSnapshot.data()!['restaurantName'],
      restaurantDescription: documentSnapshot.data()!['restaurantDescription'],
      hotlineNum: documentSnapshot.data()!['restaurantHotline'],
      imageURL: documentSnapshot.data()!['imageURL'],
    );
  }
}
