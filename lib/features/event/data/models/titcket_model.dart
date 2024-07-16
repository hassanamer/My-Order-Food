import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required final String userId,
    required final String message,
    required final String senderName,
    required final String receiverName,
  }) : super(userId, message, senderName, receiverName);

// i am using this
  factory MessageModel.fromjson(Map<String, dynamic> json) {
    return MessageModel(
      userId: json['userId'],
      message: json['message'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
    );
  }

  factory MessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return MessageModel(
      userId: documentSnapshot.data()!['userId'],
      message: documentSnapshot.data()!['message'],
      senderName: documentSnapshot.data()!['senderName'],
      receiverName: documentSnapshot.data()!['receiverName'],
    );
  }

  Map<String, dynamic> toDocument() => {
        'idUser': userId,
        'message': message,
        'senderName': senderName,
        'receiverName': receiverName,
      };

  Map<String, dynamic> toJson() => {
        'idUser': userId,
        'message': message,
      };
}

class ChattModel {
  String idUser;
  String message;
  String timestamp;
  String senderEmail;

  ChattModel(
      {required this.idUser,
      required this.message,
      required this.timestamp,
      required this.senderEmail});

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'message': message,
      'timestamp': timestamp,
      'senderEmail': senderEmail,
    };
  }

  factory ChattModel.fromjson(Map<String, dynamic> json) {
    return ChattModel(
      idUser: json['idUser'],
      message: json['message'],
      timestamp: json['timestamp'],
      senderEmail: json['senderEmail'],
    );
  }

  factory ChattModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return ChattModel(
      idUser: documentSnapshot.data()['idUser'],
      message: documentSnapshot.data()['message'],
      timestamp: documentSnapshot.data()['timestamp'].toString(),
      senderEmail: documentSnapshot.data()['senderEmail'],
    );
  }
}
