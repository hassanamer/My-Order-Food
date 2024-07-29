import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_model.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveNotification(String title, String message) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    String userId = user.uid;

    NotificationModel notification = NotificationModel(
        userId: userId,
        title: title,
        message: message,
        timestamp: DateTime.now(),
        notificationNotSeenYet: false);

    try {
      await _firestore.collection('notifications').add(notification.toMap());
      print("Notification saved successfully");
    } catch (e) {
      print("Error saving notification: $e");
    }
  }

  static Future<List<NotificationModel>> getUserNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    String userId = user.uid;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      List<NotificationModel> notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return notifications;
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }
}
