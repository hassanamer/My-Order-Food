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
import '../../main.dart';
import 'my_firebase_notification.dart';

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
      "private_key_id": "5b7ec6d5a5475f3c5a85b3db8abb1c18d4df2b42",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDWF1Y7CEmeXm/m\nkUiGbYixaDxQF8CpPOKJMXjpBddd0DZBHG319IvaG1w3XGlYwe2zeKKeelqZj/it\nsm+MRJKeESneEoIP87DttIr+mwuK41GI/fZw6TmP0ufCLnTDkOqDNndqfC82cvtV\n98FX/SO0b0O18n/pPY1WD6tIE40+9U07OC53gL7vx2Ct4hN0n5UxmLfbSApDFYMS\nys3L86YDEB5wyoa9gx+Sql19zn28qrulsR3F2xN4BIFp3IScMsTGWxkjP0yoUKyK\nBODcIj+3sWfo/MGbSodn9VHcoybVO07ecPGz+tod401aNBb+E2q+dDDt/pbhcmIp\nf/ZoqdXzAgMBAAECggEAH8F8Z+s1yEjnvkKEiHQM14vHjnXHfRLr4z+0WJQmOuMc\neRH3eYkZiXOPfSK2+ZRiZsGZFXq+n5KMZ29VPnAZc1rGZAtIwYb7Enc6OsPStXo8\naN6KxHrDsAKvn8z2Qt/m+SmGEwRymFf70eebBSsmNahfWcirknQv17khReKoi9Lf\ndzaivohQp71YqmWf3inZNsLMgz2BEmha9EV0gIqkPkojYIutadMksRLKw396ra+1\nkymTRL39NIqsaq1gGTr9xDeYBauihy7ESxhzoO5g9EUufeNyTuqSRc4w/5SzqjRN\nmoOrOWYEx3CQMaIyKW0EmJ0klkIayUcTrp+HBNlUiQKBgQDvKqzzDsPrVrVUZeos\nVc73ivjozr8X7xXKF37s9XdLacnyyLxGoUvv2Pq8hexW+J8DOu3sJ11fZqt9aCRR\nT3s7NOX8hB4JX4PzQOXVwslBbai9H+0bDu+Qu5BDkfisvCZXTy9i/QG4A6J94vJr\nOGQhEwC5HTe088FzWuDgKSoxvQKBgQDlKNkhn3xoJpflk2jl8N5GC6TbnA8Pqtby\nZrR8XvLW7UWZlgPSrRg6wP6O695NSgbXcVea5aQFlg05saraxc08voh2Jxrv8JIQ\nU1iKEzYhD2979duv3HgBfLC4f8PAd4TlDROH/2Mm9mBRAFGOZIE6TMjXCAkIwxyJ\now7p4/MpbwKBgQCIpVVTOahumYfYxLHaytwJSvmT6iv8PLmyUWJPeJ/EEpkzgcUw\nhY+hZdM8SzgRKNORQOYW+xa6Hyrz58B4RHUgCsUsVT/kExKMtROb4kKig0jZZZhO\n0WXGx6NRN+Fgr88oKzHj2LJWtJzuV/AxmnJ7AyRyn2LonCx3AAFjkaFt8QKBgDmC\nYdN1UeRVYyNjNh0WsMGFZI8UgBcfeagFrF/V+D2F+ESOCFGTzRPZoUi+2uAspsDk\nmeauoNYiDRmgg885esM20cpNEA6NIirkr8CfB6OOWx0R21ssChXddAApWDfyBrDw\n8ijcJ8b8Z7mMSethP6kg4fpM8u92/69u82wxH7ITAoGBAIdEGI6w6skiPNiXpV6Y\noryaKhGK+uTVufsLXx6eKeDnWKoEhyURF5yP7h8FWvogEe8KH3IEiZ0Ym24aLZdo\nylrqbiTH++PGYyE/8FrLTyFh376Lw0YCMFhObNk8WEYEWhGfPacQjr8lXN9LqOmG\nZiZ5P025B+VnNT17rAeNslqL\n-----END PRIVATE KEY-----\n",
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

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          if (kDebugMode) {
            print('$message');
          }
        }
        handleNotification(message);
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        String payloadData = jsonEncode(message.data);
        print("GOT MESSAGE IN THE FOREGROUND");
        if (message.notification != null) {
          PushNotification.showSimpleNotification(
              title: message.notification!.title!,
              body: message.notification!.body!,
              payload: payloadData);
        }
      });
      final RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        handleNotification(message);
      }
    }
  }

  static Future<void> sendNotificationToUser(
      String? userId, String? body) async {
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
          'title': '$body',
          'body': '$body',
        },
        'data': {}
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
