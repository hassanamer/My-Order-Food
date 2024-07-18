import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/core/services/awesome_notification_service.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

class FirebaseDatasourceProvider {
  static final _firebaseDatasourceProvider =
      FirebaseDatasourceProvider._internal();

  factory FirebaseDatasourceProvider() {
    return _firebaseDatasourceProvider;
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseDatasourceProvider._internal();
}

abstract class RemoteOrderDatasourceInterface
    extends FirebaseDatasourceProvider {
  RemoteOrderDatasourceInterface() : super._internal();

  Future<List<CreateOrderEntity>> getAllOrders();

  Future<RegisterAccountModel> getUser(String userId);

  Future<BaseResponse> addOrder(OrderModel orderModel);

  Future<BaseResponse> updateOrder(OrderModel orderModel);

  Future<BaseResponse> deleteOrders();

  Future<BaseResponse> uploadMessage(
      String idUser, String message, Account account);
}

class RemoteOrderDatasource extends RemoteOrderDatasourceInterface {
  RemoteOrderDatasource() : super();

  @override
  Future<BaseResponse> addOrder(OrderModel orderModel) async {
    try {
      await firebaseFirestore.collection("Order").doc(orderModel.id).set({
        "userId": orderModel.userId,
        "items": orderModel.items?.map((item) => item.toMap()).toList(),
        "id": orderModel.id,
        "title": orderModel.title,
      });
      await AwesomeNotificationService.showNotification(
          title: orderModel.title ?? '', body: '');
      return BaseResponse(status: true, message: "Order Added Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> deleteOrders() async {
    try {
      firebaseFirestore.collection('Order').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      return BaseResponse(status: true, message: "Orders Deleted Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<List<CreateOrderEntity>> getAllOrders() async {
    final retrieve = firebaseFirestore.collection("Order");
    final querySnapshot = await retrieve.get();
    List<CreateOrderEntity> orders = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      var data = doc.data();
      orders.add(CreateOrderEntity(
        id: doc.id,
        userId: data['userId'] ?? '',
        title: data['title'] ?? '',
        items: (data['items'] as List<dynamic>?)
            ?.map((item) => OrderItem(
                  itemName: item['itemName'] ?? '',
                  quantity: item['quantity'] ?? 0,
                  userId: item['userId'] ?? '',
                ))
            .toList(),
      ));
    }
    return orders;
  }

  //
  // @override
  // Future<List<RegisterAccountEntity>> getUserOrders() async {
  //   final retrieve = firebaseFirestore.collection("Users");
  //   final querySnapshot = await retrieve.get();
  //   List<RegisterAccountEntity> users = [];
  //   for (QueryDocumentSnapshot<Map<String, dynamic>> doc
  //       in querySnapshot.docs) {
  //     var data = doc.data();
  //     users.add(RegisterAccountEntity(
  //       // id: doc.id,
  //       email: data['email'],
  //       name: data['name'],
  //       gender: data['gender'],
  //       phoneNumber: data['phoneNumber'],
  //       username: data['userName'],
  //       idUser: data['idUser'],
  //     ));
  //   }
  //   return users;
  // }

  @override
  Future<RegisterAccountModel> getUser(String userId) async {
    final retrieve = firebaseFirestore.collection("Users").doc(userId);
    final querySnapshot = await retrieve.get();
    RegisterAccountModel registerAccountModel = RegisterAccountModel.fromMap(
        querySnapshot.data() as Map<String, dynamic>?);

    return registerAccountModel;
  }

  @override
  Future<BaseResponse> updateOrder(OrderModel orderModel) async {
    try {
      await firebaseFirestore.collection("Order").doc(orderModel.id).update({
        "userId": orderModel.userId,
        "items": orderModel.items?.map((item) => item.toMap()).toList(),
        "id": orderModel.id,
        "title": orderModel.title,
      });
      return BaseResponse(status: true, message: "Order Updated Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> uploadMessage(
      String idUser, String message, Account account) async {
    try {
      var uID = firebaseAuth.currentUser!.uid;
      final currentUser = firebaseAuth.currentUser!.email;
      await firebaseFirestore.collection("Messages").add({
        'idUser': uID,
        'message': message,
        'timestamp': DateTime.now(),
        'senderEmail': currentUser,
      });
      return BaseResponse(status: true, message: "Message Sent Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }
}
