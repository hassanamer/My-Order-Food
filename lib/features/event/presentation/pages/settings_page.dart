import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:order/core/widgets/app_bar_widget.dart';

import '../../../../core/theming/styles.dart';
import '../../../cart/presentation/pages/view_order_page.dart';
import '../../../login/presentation/cubit/login_cubit.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../../../restaurant/presentation/cubit/restaurant_cubit.dart';
import '../../../restaurant/presentation/pages/add_restaurant_page.dart';
import '../../../restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';
import 'widgets/settings_widgets/settings_header_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 16);
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: "Settings",
      ),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              _buildSettingsTile(
                child: const SettingsHeaderWidget(),
                onTap: null, // No tap action for the header
              ),
              sizedBox,
              _buildSettingsTile(
                context: context,
                text: 'Your Orders',
                icon: Icons.text_snippet_outlined,
                onTap: () {
                  context.read<RestaurantCubit>().getAllRestaurants();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ViewOrderPage()));
                },
              ),
              sizedBox,
              _buildSettingsTile(
                context: context,
                text: 'Restaurants',
                icon: Icons.table_restaurant_outlined,
                onTap: () {
                  context.read<RestaurantCubit>().getAllRestaurants();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AllRestaurantPage()));
                },
              ),
              sizedBox,
              _buildSettingsTile(
                context: context,
                text: 'Add Restaurant',
                icon: Icons.add_box_outlined,
                onTap: () {
                  Get.to(() => const RestaurantPage());
                },
              ),
              sizedBox,
              const Divider(
                thickness: 1,
                indent: 30,
                endIndent: 30,
              ),
              sizedBox,
              _buildSettingsTile(
                context: context,
                text: 'Log out',
                icon: Icons.logout_outlined,
                isShowEndIcon: false,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Logout",
                          style: TextStyles.font18BlueSemiBold,
                        ),
                        content: const Text(
                          "Are you sure you want to logout?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text(
                              'Cancel',
                              style: TextStyles.font14BlueSemiBold,
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              "Confirm",
                              style: TextStyles.font14BlueSemiBold,
                            ),
                            onPressed: () {
                              context.read<LoginCubit>().logOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    BuildContext? context,
    String? text,
    IconData? icon,
    Widget? child,
    VoidCallback? onTap,
    bool isShowEndIcon = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: child ??
              ListTile(
                leading: Icon(icon, color: Colors.white),
                trailing: isShowEndIcon
                    ? const Icon(Icons.arrow_circle_right, color: Colors.white)
                    : null,
                title: Text(
                  text ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
        ),
      ),
    );
  }
}
