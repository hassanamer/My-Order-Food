import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/features/cart/data/models/cart_items_model.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';

import '../../../restaurant/data/model/menu_model.dart';

class FirebaseDatasourceProvider {
  static final _firebaseDatasourceProvider =
      FirebaseDatasourceProvider._internal();

  factory FirebaseDatasourceProvider() {
    return _firebaseDatasourceProvider;
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseDatasourceProvider._internal();
}

abstract class CartDatasourceInterface extends FirebaseDatasourceProvider {
  CartDatasourceInterface() : super._internal();

  Future<BaseResponse> addProductToCart(MenuModel menuModel);
  Future<BaseResponse> addCartData(CartItemModel cartItemModel);
  Future<List<MenuModel>> getAllCartItems();
  Future<List<MenuModel>> viewwOrder();
  Future<BaseResponse> clearCartItems();
}

class CartDatasourceImpl extends CartDatasourceInterface {
  CartDatasourceImpl() : super();

  @override
  Future<BaseResponse> addProductToCart(MenuModel menuModel) async {
    try {
      await firebaseFirestore.collection('Cart').doc().set({
        'name': menuModel.name,
        'price': menuModel.price,
      });
      await firebaseFirestore.collection('order_save').doc().set({
        'name': menuModel.name,
        'price': menuModel.price,
      });
      return BaseResponse(
          status: true,
          message: "Item added , ${menuModel.name} was added to your cart");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> addCartData(CartItemModel cartItemModel) async {
    try {
      await firebaseFirestore.collection("checkout_list").doc().set({
        'name': cartItemModel.name,
        'price': cartItemModel.price,
        'quantity': cartItemModel.quantity,
      });
      return BaseResponse(
          status: true,
          message: "Item added , ${cartItemModel.name} to checkout list");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<List<MenuModel>> getAllCartItems() async {
    final retrive = firebaseFirestore.collection('Cart');
    final querySnapshot = await retrive.get();
    querySnapshot.docs.map((e) => e.data()).toList();
    List<MenuModel> cartItems = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      cartItems.add(MenuModel.fromSnapShot(doc));
    }
    return cartItems;
  }

  @override
  Future<List<MenuModel>> viewwOrder() async {
    final retrive = firebaseFirestore.collection('order_save');
    final querySnapshot = await retrive.get();
    querySnapshot.docs.map((e) => e.data()).toList();
    List<MenuModel> cartItems = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      cartItems.add(MenuModel.fromSnapShot(doc));
    }
    return cartItems;
  }

  @override
  Future<BaseResponse> clearCartItems() async {
    try {
      firebaseFirestore.collection('Cart').get().then((snapshot) {
        for (DocumentSnapshot documents in snapshot.docs) {
          documents.reference.delete();
        }
      });
      return BaseResponse(status: true, message: "Cart cleared Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }
}
