class CreateOrderEntity {
  final String? id;
  final String? userId;
  final String? title;
  late final List<OrderItem>? items;

  CreateOrderEntity({
    this.id,
    this.userId,
    this.title,
    this.items,
  });
}

class OrderItem {
  String userId;
  String itemName;
  int quantity;

  OrderItem({
    required this.userId,
    required this.itemName,
    this.quantity = 0,
  });

  Map<String, dynamic> toMap() {
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
    );
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
