import 'package:flutter/material.dart';
import 'package:order/features/cart/presentation/pages/cart_page.dart';
import 'package:order/features/event/presentation/pages/order_food_home_page.dart';
import 'package:order/features/event/presentation/pages/settings_page.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  final List<PersistentTabItem> items;

  const PersistentBottomBarScaffold({required this.items, super.key});

  @override
  PersistentBottomBarScaffoldState createState() =>
      PersistentBottomBarScaffoldState();
}

class PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedTab,
          children: widget.items
              .map<Widget>((PersistentTabItem page) => Navigator(
                    key: page.navigatorkey,
                    onGenerateInitialRoutes:
                        (NavigatorState navigator, String initialRoute) {
                      return <Route<dynamic>>[
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => page.tab)
                      ];
                    },
                  ))
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            if (index == _selectedTab) {
              widget.items[index].navigatorkey?.currentState
                  ?.popUntil((Route<dynamic> route) => route.isFirst);
            } else {
              setState(() {
                _selectedTab = index;
              });
            }
          },
          items: widget.items
              .map((PersistentTabItem item) => BottomNavigationBarItem(
                  icon: Icon(item.icon), label: item.title))
              .toList(),
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

/// Model class that holds the tab info for the [PersistentBottomBarScaffold]
class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final IconData icon;

  PersistentTabItem({
    required this.tab,
    required this.title,
    required this.icon,
    this.navigatorkey,
  });
}

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> _tab1navigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _tab2navigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _tab3navigatorKey =
      GlobalKey<NavigatorState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: <PersistentTabItem>[
        PersistentTabItem(
          tab: const OrderFoodHomePage(),
          icon: Icons.home_outlined,
          title: 'Home',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const CartPage(),
          icon: Icons.shopping_cart_outlined,
          title: 'Cart',
          navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: const SettingsPage(),
          icon: Icons.settings_outlined,
          title: 'Settings',
          navigatorkey: _tab3navigatorKey,
        ),
      ],
    );
  }
}
