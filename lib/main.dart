import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:order/core/bloc_observer/bloc_observer.dart';
import 'package:order/core/theme_app.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/cart/presentation/pages/cart_page.dart';
import 'package:order/features/event/presentation/pages/order_food_home_page.dart';
import 'package:order/features/event/presentation/pages/settings_page.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/register/user/pages/user_profile_screen.dart';
import 'package:order/features/restaurant/presentation/cubit/menu_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/add_restaurant_page.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';
import 'package:order/features/restaurant/presentation/pages/menu_page/menu_page.dart';

import 'core/services/awesome_notification_service.dart';
import 'core/widgets/welcome_splash_widget.dart';
import 'features/event/presentation/cubit/order_cubit.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/register/presentation/pages/register_page.dart';
import 'features/register/user/profile_cubit.dart';
import 'firebase_options.dart';
import 'injection_container.dart'
    as di; // di shortcut for Dependency injection.

void main() async {
  di.init();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AwesomeNotificationService.initializeNotification();
    await FirebaseMessaging.instance.getInitialMessage();
    await FirebaseMessaging.instance.requestPermission();
    Bloc.observer = MyGlobalObserver();
    runApp(const MyApp());
  }, (e, s) {});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late RegisterAccountRepository userRepository;
  // late RegisterAccountModel registerAccountModel;

  // Future<void> updateUserFcmToken() async {
  //   _userFcmToken = await _fcm.getToken();
  //   setState(() {
  //     registerAccountModel.fcmToken = _userFcmToken;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // updateUserFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    // String? userId = FirebaseAuth.instance.currentUser?.uid;

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<LoginCubit>()),
          BlocProvider(create: (_) => di.sl<RegisterCubit>()),
          BlocProvider(create: (_) => di.sl<OrderCubit>()..getAllOrders()),
          BlocProvider(
              create: (_) => di.sl<RestaurantCubit>()..getAllRestaurants()),
          BlocProvider(create: (_) => di.sl<MenuCubit>()..getAllMenu()),
          BlocProvider(create: (_) => di.sl<CartCubit>()..getAllCartItems()),
          BlocProvider(create: (_) => di.sl<ProfileCubit>()),
          BlocProvider(
              create: (_) => di.sl<ProfileCubit>()..fetchUserProfile()),
        ],
        child: GetMaterialApp(
          title: 'Food App',
          theme: appTheme,
          debugShowCheckedModeBanner: false,
          routes: {
            'login': (context) => const LoginPage(),
            'register': (context) => const RegisterPage(),
            'home': (context) => const OrderFoodHomePage(),
            'restaurant': (context) => const RestaurantPage(),
            'menu': (context) => const MenuPage(),
            'allrestaurant': (context) => const AllRestaurantPage(),
            'cart': (context) => const CartPage(),
            'settings': (context) => const SettingsPage(),
            'profile': (context) => UserProfileScreen(),
          },
          home: const WelcomeSplashWidget(),
        ));
  }
}
