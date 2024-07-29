import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String userId;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool notificationNotSeenYet;

  NotificationModel({
    required this.userId,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.notificationNotSeenYet,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      userId: data['userId'],
      title: data['title'],
      message: data['message'],
      notificationNotSeenYet: data['notificationNotSeenYet'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'notificationNotSeenYet': notificationNotSeenYet,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
