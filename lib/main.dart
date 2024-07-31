import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:order/core/bloc_observer/bloc_observer.dart';
import 'package:order/core/services/my_firebase_notification.dart';
import 'package:order/core/theme_app.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/event/presentation/pages/order_food_home_page.dart';
import 'package:order/features/event/presentation/pages/settings_page.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/notification/notification_page.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/add_restaurant_page.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';
import 'package:order/features/restaurant/presentation/pages/menu_page/menu_page.dart';

import 'core/services/awesome_notification_service.dart';
import 'core/services/notification_cubit.dart';
import 'core/widgets/welcome_splash_widget.dart';
import 'features/event/presentation/cubit/order_cubit.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/register/presentation/pages/profile_page.dart';
import 'features/register/presentation/pages/register_page.dart';
import 'features/register/user/profile_cubit.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

final navigatorKey = GlobalKey<NavigatorState>();
final List<Map<String, String>> _notifications = [];

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("NOTIFICATION RECEIVED IN THE BACKGROUND");
    _notifications.add({
      'title': message.notification!.title ?? 'No Title',
      'body': message.notification!.body ?? 'No Body',
    });
  }
}

void main() async {
  di.init();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await PushNotification.init();
    await PushNotification.localNotificationInit();

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String payloadData = jsonEncode(message.data);
      print("GOT MESSAGE IN THE FOREGROUND");
      if (message.notification != null) {
        PushNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData,
        );
      }
      handleNotification(message);
    });

    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('Launched FROM TERMINATED');
      handleNotification(initialMessage);
    }

    await AwesomeNotificationService.initializeNotification();

    Bloc.observer = MyGlobalObserver();

    runApp(const MyApp());
  }, (e, s) {
    print(e);
    print(s);
  });
}

void handleNotification(RemoteMessage message) {
  final notification = {
    'title': message.notification?.title ?? 'No Title',
    'body': message.notification?.body ?? 'No Body',
  };
  _notifications.add(notification);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotification pushNotification = PushNotification();

  @override
  void initState() {
    pushNotification.getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Set the design size of your UI
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<LoginCubit>()),
            BlocProvider(create: (_) => di.sl<RegisterCubit>()),
            BlocProvider(create: (_) => di.sl<OrderCubit>()..getAllOrders()),
            BlocProvider(
                create: (_) => di.sl<RestaurantCubit>()..getAllRestaurants()),
            BlocProvider(create: (_) => di.sl<CartCubit>()..getAllCartItems()),
            BlocProvider(create: (_) => di.sl<ProfileCubit>()),
            BlocProvider(
                create: (_) => di.sl<ProfileCubit>()..fetchUserProfile()),
            BlocProvider(create: (_) => di.sl<NotificationCubit>()),
            // Add your NotificationCubit here
          ],
          child: GetMaterialApp(
            title: 'Food App',
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            routes: {
              'splash': (context) => const WelcomeSplashWidget(),
              'login': (context) => const LoginPage(),
              'register': (context) => const RegisterPage(),
              'home': (context) => const OrderFoodHomePage(),
              'restaurant': (context) => const RestaurantPage(),
              'menu': (context) => const MenuPage(),
              'allrestaurant': (context) => const AllRestaurantPage(),
              // 'cart': (context) => const CartPage(),
              'settings': (context) => const SettingsPage(),
              'profile': (context) => const ProfilePage(),
              'notifications': (context) => NotificationPage(),
            },
            initialRoute: 'splash',
          ),
        );
      },
    );
  }
}
