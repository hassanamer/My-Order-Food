class CreateOrderEntity {
  final String? id;
  final String userId;
  final String? title;
  late final Map<String, dynamic>?
      items; // Map to store items and their quantities

  CreateOrderEntity({
    this.id,
    required this.userId,
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

// Other constructors, methods, etc.
