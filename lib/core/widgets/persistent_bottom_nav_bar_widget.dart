import 'package:flutter/material.dart';
import 'package:order/features/orders/presentation/pages/widgets/home_widgets/home/order_food_home_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/settings_widgets/settings_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/create_order_pages/create_order_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      // Updated parameters
      // Remove deprecated or renamed parameters
      // confineInSafeArea: true,
      // itemAnimationProperties: const ItemAnimationProperties(
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeInOut,
      // ),
      // screenTransitionAnimation: const ScreenTransitionAnimation(
      //   animateTabTransition: true,
      //   curve: Curves.easeInOut,
      //   duration: Duration(milliseconds: 300),
      // ),
      navBarStyle: NavBarStyle.style1,
    );
  }

  List<Widget> _buildScreens() {
    return <Widget>[
      const OrderFoodHomePage(),
      const CreateOrderPage(isUpdateEvent: false),
      const SettingsPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return <PersistentBottomNavBarItem>[
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: 'Home',
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_box_outlined),
        title: 'Add',
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_outlined),
        title: 'Settings',
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
