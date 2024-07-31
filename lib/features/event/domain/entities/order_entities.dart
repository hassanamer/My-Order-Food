import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/order_model.dart';

class OrderEntity {
  final String id;
  final String? userId;
  final String? title;
  final DateTime createdAt;
  OrderStatusEnum status;
  late final List<OrderItem>? items;

  OrderEntity({
    required this.id,
    this.userId,
    this.title,
    this.items,
    required this.createdAt,
    required this.status,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      id: map["id"],
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: OrderStatusEnum.values[map['status'] ?? 0],
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.index,
      'items': items?.map((item) => item.toMap()).toList(),
    };
  }

  toOrderModel() {
    return OrderModel(
      userId: userId,
      id: id,
      title: title,
      items: items,
      createdAt: createdAt,
      status: status,
    );
  }
}

class OrderItem {
  String userId;
  String itemName;
  int quantity;
  double? price;
  double? totalPrice;

  OrderItem({
    required this.userId,
    required this.itemName,
    this.quantity = 0,
    this.price,
    this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'price': price,
      'itemName': itemName,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  Map<String, dynamic> withoutPriceToMap() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'userId': userId,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemName: map['itemName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      userId: map['userId'] ?? '',
      price: map['price'],
      totalPrice: map['totalPrice'],
    );
  }
}

enum OrderStatusEnum {
  active,
  placed,
  arrived;

  String get name {
    switch (this) {
      case OrderStatusEnum.active:
        return 'Active';
      case OrderStatusEnum.placed:
        return 'Placed';
      case OrderStatusEnum.arrived:
        return 'Arrived';
      default:
        return '';
    }
  }
}

class CommentEntity {
  int? id;
  String comment;

  CommentEntity({this.id, required this.comment});
}

class BaseResponse {
  bool status;
  String message;

  BaseResponse({required this.status, required this.message});
}

class MessageEntity {
  final String userId;
  final String message;
  final String senderName;
  final String receiverName;

  MessageEntity(
    this.userId,
    this.message,
    this.senderName,
    this.receiverName,
  );
}
