import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    String? userId,
    required String id,
    String? title,
    List<OrderItem>? items,
    int? itemCount,
    String? createdAt,
    String? status,
  }) : super(
          userId: userId,
          id: id,
          title: title,
          items: items,
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
      "status": status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        userId: map['userId'],
        id: map['id'],
        title: map['title'],
        itemCount: map['itemCount'],
        createdAt: map['createdAt'],
        status: map['status'],
        items: map['items']
            ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
            .toList());
  }

  factory OrderModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return OrderModel(
        userId: documentSnapshot.data()!['userId'],
        id: documentSnapshot.data()!['id'],
        title: documentSnapshot.data()!['title'],
        itemCount: documentSnapshot.data()!['itemCount'],
        createdAt: documentSnapshot.data()!['createdAt'],
        status: documentSnapshot.data()!['status'],
        items: documentSnapshot
            .data()!['items']
            ?.map<OrderItem>((item) => OrderItem.fromMap(item))
            .toList());
  }

  // factory EventModel.fromSnapShot2(
  //     DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
  //   return EventModel(
  //     comment: documentSnapshot.data()!['comment'],
  //   );
  // }

  factory OrderModel.fromEntity(OrderEntity eventEntity) => OrderModel(
        userId: eventEntity.userId,
        id: eventEntity.id,
        title: eventEntity.title,
        items: eventEntity.items,
        createdAt: eventEntity.createdAt,
        status: 'active',
      );
}
