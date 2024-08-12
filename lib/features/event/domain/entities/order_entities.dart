import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order/features/event/data/models/order_model.dart';

class OrderEntity {
  final String id;
  final String? userId;
  final String? title;
  final DateTime createdAt;
  double? deliveryFees;
  OrderStatusEnum status;
  double vat = 0;
  late final List<OrderItem>? items;
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
          ?.map((item) => OrderItem.fromMap(item))
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
      'items': items?.map((OrderItem item) => item.toMap()).toList(),
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

class OrderItem {
  String userId;
  String itemName;
  int quantity;
  double? price;
  double? itemTotalPrice;

  OrderItem({
    required this.userId,
    required this.itemName,
    this.quantity = 0,
    this.price,
    this.itemTotalPrice,
  });

  Map<String, dynamic> toMap() {
    // ignore: always_specify_types
    return {
      'userId': userId,
      'price': price,
      'itemName': itemName,
      'quantity': quantity,
      'itemTotalPrice': itemTotalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemName: map['itemName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      userId: map['userId'] ?? '',
      price: map['price'],
      itemTotalPrice: map['itemTotalPrice'],
    );
  }
}

enum OrderStatusEnum {
  active(
      title: 'Active',
      color: Colors.yellow,
      icon: Icons.hourglass_top_outlined,
      descreption: 'This Order Is Active'),
  placed(
      title: 'Placed',
      color: Colors.blue,
      icon: Icons.local_shipping_outlined,
      descreption: 'This order is on it\'s way to you.'),
  arrived(
      title: 'Arrived',
      color: Colors.white,
      icon: Icons.task_alt_outlined,
      descreption: 'Thank you for ordered with us.'),
  cancelled(
      title: 'Cancelled',
      color: Colors.red,
      icon: Icons.cancel_outlined,
      descreption:
          'No One Joined This Order SO Unforgettably \n It Was Cancelled.');

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
      case OrderStatusEnum.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }

  static Color getStatusColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.active:
        return Colors.white;
      case OrderStatusEnum.placed:
        return Colors.white;
      case OrderStatusEnum.arrived:
        return Colors.white;
      case OrderStatusEnum.cancelled:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}

class CommentEntity {
  int? id;
  String comment;

  CommentEntity({required this.comment, this.id});
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
