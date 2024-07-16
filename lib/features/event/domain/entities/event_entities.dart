class EventEntity {
  final String? id;
  final String? title;
  final String? item;
  late final Map<String, dynamic>?
      items; // Map to store items and their quantities

  EventEntity({
    this.id,
    this.title,
    this.item,
    this.items,
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
