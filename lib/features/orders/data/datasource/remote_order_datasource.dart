import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/features/notification/data/datasources/awesome_notification_service.dart';
import 'package:order/features/orders/data/models/order_model.dart';
import 'package:order/features/orders/domain/entities/order_entities.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

class FirebaseDatasourceProvider {
  static final FirebaseDatasourceProvider _firebaseDatasourceProvider =
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

  Future<BaseResponse> deleteOrderById(String orderId);
}

class RemoteOrderDatasource extends RemoteOrderDatasourceInterface {
  RemoteOrderDatasource() : super();

  @override
  Future<BaseResponse> addOrder(OrderModel orderModel) async {
    try {
      await firebaseFirestore
          .collection('Order')
          .doc(orderModel.id)
          .set(orderModel.toMap());
      await AwesomeNotificationService.showNotification(
          title: orderModel.title ?? '', body: '');
      return BaseResponse(status: true, message: 'Order Added Successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> deleteOrderById(String orderId) async {
    try {
      await firebaseFirestore.collection('Order').doc(orderId).delete();
      return BaseResponse(status: true, message: 'Order Deleted Successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    final CollectionReference<Map<String, dynamic>> retrieve =
        firebaseFirestore.collection('Order');
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await retrieve.get();
    List<OrderEntity> orders = <OrderEntity>[];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      orders.add(OrderEntity.fromMap(data));
    }
    return orders;
  }

  @override
  Future<RegisterAccountModel> getUser(String userId) async {
    final DocumentReference<Map<String, dynamic>> retrieve =
        firebaseFirestore.collection('Users').doc(userId);
    final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await retrieve.get();
    RegisterAccountModel registerAccountModel =
        RegisterAccountModel.fromMap(querySnapshot.data());

    return registerAccountModel;
  }

  @override
  Future<BaseResponse> updateOrder(OrderModel orderModel) async {
    print('done');
    try {
      await firebaseFirestore
          .collection('Order')
          .doc(orderModel.id)
          .update(orderModel.toMap());
      return BaseResponse(status: true, message: 'Order Updated Successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<OrderEntity> getOrder(String orderId) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firebaseFirestore.collection('Order').doc(orderId).get();

    Map<String, dynamic> data = doc.data()!;
    return OrderEntity.fromMap(data);
  }

  @override
  Future<BaseResponse> updateOrderStatus(
      String orderId, OrderStatusEnum newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .update(<Object, Object?>{'status': newStatus.index});

      return BaseResponse(
          status: true, message: 'Order Status Updated Successfully');
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }
}
