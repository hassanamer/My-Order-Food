import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_model.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveNotification(
      String title, String message, String? userId) async {
    if (userId == null) {
      return;
    }
    NotificationModel notification = NotificationModel(
      id: '',
      userId: userId,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      notificationSeen: false,
    );

    try {
      DocumentReference docRef = await _firestore
          .collection('notifications')
          .add(notification.toMap());
      await docRef.update({'id': docRef.id});
      print("Notification saved successfully");
    } catch (e) {
      print("Error saving notification: $e");
    }
  }

  static Future<List<NotificationModel>> getCurrentUserNotifications() async {
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
        final data = doc.data() as Map<String, dynamic>;
        return NotificationModel.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();

      return notifications;
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  static Stream<List<NotificationModel>> currentUserNotificationsStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    String userId = user.uid;

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NotificationModel.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  static Future<void> updateNotification(NotificationModel notification) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      await _firestore
          .collection('notifications')
          .doc(notification.id)
          .update(notification.toMap());
      print("Notification updated successfully");
    } catch (e) {
      print("Error updating notification: $e");
    }
  }
}
