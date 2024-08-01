import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';

class OrderEntity {
  final String id;
  final String? userId;
  final String? title;
  final DateTime createdAt;
  OrderStatusEnum status;
  late final List<OrderItem>? items;
  Map<String, double> userTotalPrices = {};

  OrderEntity({
    required this.id,
    this.userId,
    this.title,
    this.items,
    required this.createdAt,
    required this.status,
    required this.userTotalPrices,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      id: map["id"],
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      userTotalPrices: (map['userTotalPrices'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value)),
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
      'userTotalPrices': userTotalPrices,
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
      userTotalPrices: userTotalPrices,
    );
  }
}

class OrderItem {
  String userId;
  String itemName;
  int quantity;
  double? price;
  double? itemsTotalPrice;

  OrderItem({
    required this.userId,
    required this.itemName,
    this.quantity = 0,
    this.price,
    this.itemsTotalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'price': price,
      'itemName': itemName,
      'quantity': quantity,
      'itemsTotalPrice': itemsTotalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemName: map['itemName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      userId: map['userId'] ?? '',
      price: map['price'],
      itemsTotalPrice: map['itemsTotalPrice'],
    );
  }
}

enum OrderStatusEnum {
  active(
      title: 'Active',
      color: Colors.green,
      icon: Icons.hourglass_top_outlined,
      descreption: 'This Order Is Active'),
  placed(
      title: 'Placed',
      color: Colors.blue,
      icon: Icons.local_shipping_outlined,
      descreption: 'This order is on it\'s way to you.'),
  arrived(
      title: 'Arrived',
      color: Colors.red,
      icon: Icons.task_alt_outlined,
      descreption: 'Thank you for ordered with us.');

  final String title;
  final String descreption;
  final IconData icon;
  final Color color;

  const OrderStatusEnum({
    required this.title,
    required this.descreption,
    required this.icon,
    required this.color,
  });

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

  static Color getStatusColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.active:
        return Colors.green;
      case OrderStatusEnum.placed:
        return Colors.yellow;
      case OrderStatusEnum.arrived:
        return Colors.red;
      default:
        return Colors.white;
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
