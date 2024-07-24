import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

import '../../features/register/domain/reposisatory/register_reprisatory.dart';
import '../../injection_container.dart';

class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final localNotifications = FlutterLocalNotificationsPlugin();
  String? _userFcmToken;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  late RegisterAccountRepository registerAccountRepository;

  PushNotificationService(this._fcm);

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "food-order-a2d6c",
      "private_key_id": "216b90e86735c6bba0e57e2e146a86fdb4e24992",
      "private_key": "YOUR_PRIVATE_KEY",
      "client_email": "food-order-a2d6c@appspot.gserviceaccount.com",
      "client_id": "110117234038964388473",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/food-order-a2d6c%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/userinfo.email",
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  void updateUserFcmToken() async {
    _userFcmToken = await _fcm.getToken();
    if (userId == null && _userFcmToken == null) {
      return;
    }
    registerAccountRepository = sl();
    registerAccountRepository.updateUserFcmToken(userId!, _userFcmToken!);
  }

  static void showLocalNotification(
      String title, String body, String payload) async {
    const androidNotificationDetail = AndroidNotificationDetails(
      '0',
      'general',
      priority: Priority.high,
      autoCancel: false,
      fullScreenIntent: true,
      enableVibration: true,
      importance: Importance.high,
      playSound: true,
    );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails,
        payload: payload);
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }
    const AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    if (_userFcmToken != null) {
      print("Using user's FCM token:$_userFcmToken");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          if (kDebugMode) {
            print('message : ${notification.body}');
          }
          const AndroidNotificationChannel channel = AndroidNotificationChannel(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
          );

          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(channel);
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: android?.smallIcon,
                  // other properties...
                ),
              ));
        }
      });

      // const AndroidInitializationSettings('ic_launcher');
      // var initialzationSettingsAndroid =
      //     const AndroidInitializationSettings('@mipmap/ic_launcher');
      // var initializationSettings =
      //     InitializationSettings(android: initialzationSettingsAndroid);
      //
      // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   RemoteNotification? notification = message.notification;
      //   AndroidNotification? android = message.notification?.android;
      //   if (notification != null && android != null) {
      //     flutterLocalNotificationsPlugin.show(
      //         notification.hashCode,
      //         notification.title,
      //         notification.body,
      //         NotificationDetails(
      //           android: AndroidNotificationDetails(
      //             '0',
      //             'general',
      //             // color: Colors.blue,
      //             icon: "@mipmap/ic_launcher",
      //           ),
      //         ));
      //   }
      // });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          // Handle the message when the app is opened from a notification
          if (kDebugMode) {
            print('$message');
          }
        }
      });
    }
  }

  static Future<void> sendNotificationToUser(
      String? userId, double? totalPrice) async {
    final String serverKey = await getAccessToken();
    const String endPointFirebaseCloudingMessaging =
        'https://fcm.googleapis.com/v1/projects/food-order-a2d6c/messages:send';
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(userId).get();
    String? userFcmToken = userDoc['fcmToken'];
    final Map<String, dynamic> message = {
      'message': {
        'token': userFcmToken,
        'notification': {
          'title': 'Your Total Price is $totalPrice',
          'body': 'Your order total is $totalPrice',
          "sound": "default",
          "payload": "Urgent"
        },
        'data': {'userFcmToken': userFcmToken}
      },
    };
    final http.Response response = await http.post(
      Uri.parse(endPointFirebaseCloudingMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed to send notification: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
