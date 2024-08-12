// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  String name;
  String description;
  int price;
  int? quentity;
  String? imageURL;

  MenuModel({
    required this.name,
    required this.description,
    required this.price,
    this.quentity,
    this.imageURL,
  });

  factory MenuModel.fromSnapShot(
      QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot) {
    return MenuModel(
      name: queryDocumentSnapshot.data()['name'] ?? '',
      description: queryDocumentSnapshot.data()['description'] ?? '',
      price: queryDocumentSnapshot.data()['price'] ?? '',
      quentity: queryDocumentSnapshot.data()['quentity'],
      imageURL: queryDocumentSnapshot.data()['imageURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageURL': imageURL,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      name: map['name'],
      description: map['description'],
      price: map['price'],
      quentity: map['quentity'],
      imageURL: map['imageURL'],
    );
  }
}
