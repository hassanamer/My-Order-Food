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
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDB4Ux8KDwaMq5o\nAXBRrGmDky7uFzWt4CzjfJDOfRzUvuk7+mFAvYaX4ZiV382Vu1tWMkHvPMjTp3jk\nbGnZQ88Wf9wSb5xj+oiGX6mHtFKaqnA3CVaZwDOSGC9MPZDW/AgGgu0H86fpQNMG\n1qldOf5k3woAyoOgvGScPGLfJlKiW9XoYQOCsB34txRim14CvlZrdjW92TsySp4W\nJuxHcOI8l7HYAgHFJADiAC5ivJIfuDpRQB/xoOfRhebuHf1XvfbbN2kjz2/h//5U\nwzNatW7DrT6F9u/oA5t9sTNxF2EktHG4B35pdIK/BejA08iNXgtDfBscqsbyMfNv\nErzlz4JrAgMBAAECggEAROdo0uFLxvXHJSCJxgUT9NaMwcJO6g43ddvR7QjrA7Mb\n2hyYjrUszfK302AYRQQyqFYxN7CvIQWugeQD1Fr0kOb9FDJFbwTdm4AJFLkh+GTl\nf7HabMcxrNTajmp8/OLSiVnjmsVeIhhPR2loBMF1J21bNT/D+w6pZRtS+kK48Ik6\nXGFUkytQZ2FtnRAlC3yCj9q6c0GgSmaKy0TBQC8fLrQGQ/9/9ZO52yRbAXYXvZM2\nnhQTIB4wdJd6rB5Cf8ZVOg5npRV0fdX9t7k8TxHZMaIYR20uIWY6rGI0h6K5lBI3\nboqiNtjombpNEPDug6D+QoDs0YG5V+/d3FmLia4dOQKBgQD7kbcl2UCWTVX0uU8S\nKtceSi40ikSqyxnO7KmSM+V2luyoxTUp7Y3wtNYdcO8pve76xViEeYMTadUrDPcA\nN861yabLboaa+DMKcGv7CHFvvn4d6YLmwJBQb8mNtqfIN//NvTLbKlt8FlfiqPaZ\njAvgQgBnVztUSByAHLCzgVV9EwKBgQDFS3jzSAtgwNHHAcYZTJhwlPtTwvV2HhRY\ndbwPwq3CHcbl966fnFNQlJasZ7g8kcjwOGRX68t0slfGNcjnQ1PwPbQvx8rfWgaY\nWZVpuR/ZU4w2VyNcNpYx2bQtRc5jVu/r03Wr5Y6gUD8Gz3teVnruCbrjADn44X+w\nAGEPSWjISQKBgAK4t9eD+yvlGEn2e0GCDyO3v7o3yLhkTBot+0OmphPbXCITSBj1\nBfUVr79PynaUJHK4EdYVDnL2USUPFdj9wZG75b8Lqg8hIkQ5pSFpHPkNgYXHUfA3\nIxiLrQ2IbVZALNdH9bXjRmwYPcko9MoCdtptPF3h1rV5tj04kjzO6GLbAoGAHdC6\nBonsrkJ1cU2jUk9w+hKJqK7dyWviRzwDn54cBCnb1QUJLrXBIXxTCNrjzMN7SlI7\nV84agRgyi5G1Or3CAZxRjqby0a4ZMQzYt5FybrVhixTAEz9skzwDLpRODFUnDMx4\nC/I1C6UU4UKZsjf/e9mclJGEMUhis4ZbJKRDYYECgYABAvggEs3XyhrREF3UlmyM\n330Xixnqvwfib20b5ezuD+0xu2UbZj217jlgHcHBJRRG2bN87GTRGi+oLoVeHKuT\nccuqZOKxmecQY+uy6CPolaoBpdxE+K6jGxn0N521bbsHd5wl5NF4FzJF9bPxmDK+\nKHdKhcxsYBMqAdZoELfjAQ==\n-----END PRIVATE KEY-----\n",
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

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // method to send notification to a specific user
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
          'title': 'your Total price is ',
          'body': 'body',
          "sound": "default",
          "payload": "Urgent"
        },
        'data': {userFcmToken}
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
