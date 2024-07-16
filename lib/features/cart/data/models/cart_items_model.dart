import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String name;
  final String quantity;
  final double price;

  CartItemModel({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  factory CartItemModel.fromSnapShot(
      QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot) {
    return CartItemModel(
      name: queryDocumentSnapshot.data()['name'],
      quantity: queryDocumentSnapshot.data()['quantity'],
      price: queryDocumentSnapshot.data()['price'],
    );
  }
}
