import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    String? userId,
    required String id,
    String? title,
    List<OrderItem>? items,
    double? deliveryFees,
    int? itemCount,
    required double vat,
    required Map<String, double> itemsTotalPricePerUser,
    required DateTime createdAt,
    required OrderStatusEnum status,
  }) : super(
          userId: userId,
          id: id,
          title: title,
          deliveryFees: deliveryFees,
          items: items,
          vat: vat,
          itemsTotalPricePerUser: itemsTotalPricePerUser,
          createdAt: createdAt,
          status: status,
        );

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      "items": items?.map((item) => item.toMap()),
      "createdAt": createdAt,
      "vat": vat,
      "itemsTotalPricePerUser": itemsTotalPricePerUser,
      "deliveryFees": deliveryFees,
      "status": status.index,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'],
      id: map['id'],
      title: map['title'],
      itemCount: map['itemCount'],
      createdAt: map['createdAt'],
      vat: map['vat'],
      deliveryFees: map['deliveryFees'],
      status: OrderStatusEnum.values[map['status']],
      items: map['items']
          ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      itemsTotalPricePerUser:
          (map['itemsTotalPricePerUser'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value)),
    );
  }

  factory OrderModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return OrderModel(
      userId: documentSnapshot.data()!['userId'],
      id: documentSnapshot.data()!['id'],
      title: documentSnapshot.data()!['title'],
      itemCount: documentSnapshot.data()!['itemCount'],
      deliveryFees: documentSnapshot.data()!['deliveryFees'],
      vat: documentSnapshot.data()!['vat'],
      createdAt: documentSnapshot.data()!['createdAt'],
      status: OrderStatusEnum.values[documentSnapshot.data()!['status']],
      items: documentSnapshot
          .data()!['items']
          ?.map<OrderItem>((item) => OrderItem.fromMap(item))
          .toList(),
      itemsTotalPricePerUser: (documentSnapshot
              .data()!['itemsTotalPricePerUser'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value)),
    );
  }

  factory OrderModel.fromEntity(OrderEntity orderEntity) => OrderModel(
        userId: orderEntity.userId,
        id: orderEntity.id,
        title: orderEntity.title,
        items: orderEntity.items,
        vat: orderEntity.vat,
        deliveryFees: orderEntity.deliveryFees,
        createdAt: orderEntity.createdAt,
        status: orderEntity.status,
        itemsTotalPricePerUser: orderEntity.itemsTotalPricePerUser,
      );
}
