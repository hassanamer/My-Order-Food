import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/features/orders/data/models/order_item_model.dart';
import 'package:order/features/orders/data/models/order_model.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_status/order_status_enum_model.dart';

class OrderEntity {
  final String id;
  final String? userId;
  final String? title;
  final DateTime createdAt;
  double? deliveryFees;
  OrderStatusEnum status;
  double vat = 0;
  late final List<OrderItemModel>? items;
  Map<String, double> itemsTotalPricePerUser = <String, double>{};
  String? placerUid;
  String? receiverUid;

  OrderEntity({
    required this.id,
    required this.vat,
    required this.deliveryFees,
    required this.createdAt,
    required this.status,
    required this.itemsTotalPricePerUser,
    this.userId,
    this.title,
    this.items,
    this.placerUid,
    this.receiverUid,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      id: map['id'],
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      receiverUid: map['receiverUid'] ?? '',
      placerUid: map['placerUid'] ?? '',
      deliveryFees: map['deliveryFees'] ?? 0.0,
      vat: map['vat'] ?? 0,
      itemsTotalPricePerUser:
          (map['itemsTotalPricePerUser'] as Map<String, dynamic>)
              // ignore: always_specify_types
              .map((String key, value) => MapEntry(key, value)),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: OrderStatusEnum.values[map['status'] ?? 0],
      items: (map['items'] as List<dynamic>?)
          // ignore: always_specify_types
          ?.map((item) => OrderItemModel.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: always_specify_types
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'placerUid': placerUid,
      'receiverUid': receiverUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.index,
      'vat': vat,
      'items': items?.map((OrderItemModel item) => item.toMap()).toList(),
      'itemsTotalPricePerUser': itemsTotalPricePerUser,
      'deliveryFees': deliveryFees,
    };
  }

  toOrderModel() {
    return OrderModel(
      userId: userId,
      id: id,
      title: title,
      items: items,
      createdAt: createdAt,
      vat: vat,
      receiverUid: receiverUid,
      placerUid: placerUid,
      status: status,
      itemsTotalPricePerUser: itemsTotalPricePerUser,
      deliveryFees: deliveryFees,
    );
  }
}

class BaseResponse {
  bool status;
  String message;

  BaseResponse({required this.status, required this.message});
}
