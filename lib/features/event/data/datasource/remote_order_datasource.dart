import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/core/services/awesome_notification_service.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
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

  Future<List<OrderEntity>> getAllOrders();

  Future<OrderEntity> getOrder(String orderId);

  Future<RegisterAccountModel> getUser(String userId);

  Future<BaseResponse> addOrder(OrderModel orderModel);

  Future<BaseResponse> updateOrder(OrderModel orderModel);

  Future<BaseResponse> updateOrderStatus(
      String orderId, OrderStatusEnum newStatus);

  Future<BaseResponse> deleteOrders();
}

class RemoteOrderDatasource extends RemoteOrderDatasourceInterface {
  RemoteOrderDatasource() : super();

  @override
  Future<BaseResponse> addOrder(OrderModel orderModel) async {
    try {
      await firebaseFirestore
          .collection("Order")
          .doc(orderModel.id)
          .set(orderModel.toMap());
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
  Future<List<OrderEntity>> getAllOrders() async {
    final retrieve = firebaseFirestore.collection("Order");
    final querySnapshot = await retrieve.get();
    List<OrderEntity> orders = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      var data = doc.data();
      orders.add(OrderEntity.fromMap(data));
    }
    return orders;
  }

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
      await firebaseFirestore
          .collection("Order")
          .doc(orderModel.id)
          .update(orderModel.toMap());
      return BaseResponse(status: true, message: "Order Updated Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<OrderEntity> getOrder(String orderId) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firebaseFirestore.collection("Order").doc(orderId).get();

    var data = doc.data()!;
    return OrderEntity.fromMap(data);
  }

  @override
  Future<BaseResponse> updateOrderStatus(
      String orderId, OrderStatusEnum newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .update({'status': newStatus.index});

      return BaseResponse(
          status: true, message: "Order Status Updated Successfully");
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }
}
