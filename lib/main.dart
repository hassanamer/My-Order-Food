// ignore_for_file: always_specify_types

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nested/nested.dart';
import 'package:order/core/bloc_observer/bloc_observer.dart';
import 'package:order/core/theming/theme_app.dart';
import 'package:order/core/widgets/welcome_splash_widget.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/notification/data/datasources/awesome_notification_service.dart';
import 'package:order/features/notification/data/datasources/push_notification_service.dart';
import 'package:order/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:order/features/notification/presentation/pages/notification_page.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/home/order_food_home_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/onborading_widgets/onboarding_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/settings_widgets/settings_page.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/register/presentation/pages/profile_page.dart';
import 'package:order/features/register/presentation/pages/register_page.dart';
import 'package:order/features/register/user/profile_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/add_restaurant_page.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';
import 'package:order/features/restaurant/presentation/pages/get_menu_pages/menu_page.dart';
import 'package:order/firebase_options.dart';
import 'package:order/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final List<Map<String, String>> _notifications = <Map<String, String>>[];

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print('NOTIFICATION RECEIVED IN THE BACKGROUND');
    _notifications.add(<String, String>{
      'title': message.notification!.title ?? 'No Title',
      'body': message.notification!.body ?? 'No Body',
    });
  }
}

int? isviewed;

void main() async {
  di.init();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isviewed = prefs.getInt('onBoard');

    await PushNotificationService.init();
    await PushNotificationService.localNotificationInit();

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String payloadData = jsonEncode(message.data);
      print('GOT MESSAGE IN THE FOREGROUND');
      if (message.notification != null) {
        PushNotificationService.showSimpleNotification(
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
  }, (Object e, StackTrace s) {
    print(e);
    print(s);
  });
}

void handleNotification(RemoteMessage message) {
  final Map<String, String> notification = <String, String>{
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
  PushNotificationService pushNotificationService = PushNotificationService();

  @override
  void initState() {
    pushNotificationService.getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Set the design size of your UI
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider(create: (_) => di.sl<LoginCubit>()),
            BlocProvider(create: (_) => di.sl<RegisterCubit>()),
            BlocProvider(create: (_) => di.sl<OrderCubit>()..getAllOrders()),
            BlocProvider(
                create: (_) => di.sl<RestaurantCubit>()..getAllRestaurants()),
            BlocProvider(create: (_) => di.sl<ProfileCubit>()),
            BlocProvider(
                create: (_) => di.sl<ProfileCubit>()..fetchUserProfile()),
            BlocProvider(create: (_) => di.sl<NotificationCubit>()),
          ],
          child: GetMaterialApp(
            title: 'Food App',
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            routes: <String, Widget Function(BuildContext p1)>{
              'splash': (BuildContext context) => const WelcomeSplashWidget(),
              'onboarding': (BuildContext context) => const OnBoard(),
              'login': (BuildContext context) => const LoginPage(),
              'register': (BuildContext context) => const RegisterPage(),
              'home': (BuildContext context) => const OrderFoodHomePage(),
              'restaurant': (BuildContext context) => const RestaurantPage(),
              'menu': (BuildContext context) => MenuPage(),
              'allrestaurant': (BuildContext context) =>
                  const AllRestaurantPage(),
              // 'cart': (context) => const CartPage(),
              'settings': (BuildContext context) => const SettingsPage(),
              'profile': (BuildContext context) => const ProfilePage(),
              'notifications': (BuildContext context) =>
                  const NotificationPage(),
            },
            initialRoute: isviewed != 0 ? 'onboarding' : 'splash',
          ),
        );
      },
    );
  }
}
