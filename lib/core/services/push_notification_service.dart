import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  void updateUserFcmToken() async {
    _userFcmToken = await _fcm.getToken();
    if (userId == null && _userFcmToken == null) {
      return;
    }
    registerAccountRepository = sl();
    registerAccountRepository.updateUserFcmToken(userId!, _userFcmToken!);
  }

  static showLocalNotification(String title, String body, String payload) {
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

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }
    const AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (_userFcmToken != null) {
      print("Using user's FCM token:$_userFcmToken");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          if (kDebugMode) {
            print('message : ${notification.body}');
          }
          FlutterLocalNotificationsPlugin().show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  // channel.description,
                  // color: Colors.blue,
                  icon: "@mipmap/ic_launcher",
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          if (kDebugMode) {
            print('$message');
          }
        }
      });
    }
  }

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  // Add this method to send notification to a specific user
  static Future<void> sendNotificationToUser(
      String? userId, double? totalPrice) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(userId).get();
    String? userFcmToken = userDoc['fcmToken'];

    if (userFcmToken != null) {
      String serverKey = 'YOUR_SERVER_KEY_HERE'; // Replace with your server key

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(<String, dynamic>{
          'to': userFcmToken,
          'notification': <String, dynamic>{
            'title': 'Order Total Price',
            'body': 'Your total price is $totalPrice L.E',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}');
      }
    }
  }
}
