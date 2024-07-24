import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:order/core/services/crud_service.dart';
import 'package:order/main.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  final CRUDService crudService = CRUDService();
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  Future getDeviceToken() async {
    //device token
    final token = await _firebaseMessaging.getToken();
    print("device token $token");
    await crudService.saveUserToken(token);

    _firebaseMessaging.onTokenRefresh.listen((event) async {
      crudService.saveUserToken(token);
    });
  }

  //intialise local notif
  static Future localNotificationInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    // request notif permession for android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  //on tap notif in the foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/allrestaurant", arguments: notificationResponse);
  }

  static Future showSimpleNotification(
      {required String title,
      required String body,
      required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: "",
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
//
// Future<void> sendNotificationToUser(
//     String? userId, String title, String body) async {
//   try {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(userId)
//         .get();
//     String? userFcmToken = userDoc['fcmToken'];
//
//     // if (userFcmToken != null) {
//     //   RemoteMessage message = await _firebaseMessaging.sendAndRetrieveMessage(
//     //     to: userFcmToken,
//     //     data: {
//     //       'title': title,
//     //       'body': body,
//     //     },
//     //   );
//
//       print("Notification sent to $userId");
//       print("Message ID: ${message.messageId}"); // Print the message ID
//     } else {
//       print("User FCM token is null");
//     }
//   } catch (e) {
//     print("Error sending notification: $e");
//   }
// }
}
