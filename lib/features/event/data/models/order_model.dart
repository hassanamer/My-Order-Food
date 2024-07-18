import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/entities/remote_chat_entities.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    int? id,
    required String comment,
  }) : super(
          id: id,
          comment: comment,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      comment: map['comment'],
    );
  }

  factory CommentModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return CommentModel(
      id: documentSnapshot.data()!['id'],
      comment: documentSnapshot.data()!['comment'],
    );
  }

  factory CommentModel.fromEntity(CommentEntity commentEntity) => CommentModel(
        id: commentEntity.id,
        comment: commentEntity.comment,
      );
}

class OrderModel extends CreateOrderEntity {
  OrderModel({
    String? userId,
    String? id,
    String? title,
    List<OrderItem>? items,
    int? itemCount,
  }) : super(
          userId: userId,
          id: id,
          title: title,
          items: items,
        );

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      "items": items,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        userId: map['userId'],
        id: map['id'],
        title: map['title'],
        itemCount: map['itemCount'],
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

  factory OrderModel.fromEntity(CreateOrderEntity eventEntity) => OrderModel(
        userId: eventEntity.userId,
        id: eventEntity.id,
        title: eventEntity.title,
        items: eventEntity.items,
      );
}

class ChateMessageModel extends ChatMessages {
  ChateMessageModel({
    String? idFrom,
    required String content,
  }) : super(
          idFrom: idFrom,
          content: content,
        );

  Map<String, dynamic> toJson() {
    return {
      idFrom!: idFrom,
      content: content,
    };
  }
}
