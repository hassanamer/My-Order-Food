import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/login/presentation/pages/login_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/order_details_page/view_order_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/settings_widgets/about_page.dart';
import 'package:order/features/orders/presentation/pages/widgets/settings_widgets/settings_header_widget.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';
import 'package:order/features/restaurant/presentation/pages/add_restaurant_page.dart';
import 'package:order/features/restaurant/presentation/pages/get_all_restaurants_page/all_restaurants_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const SizedBox sizedBox = SizedBox(height: 16);
    return Scaffold(
      appBar: const AppBarWidget(
        pageName: 'Settings',
      ),
      backgroundColor: Colors.blue[600],
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (Widget widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: <Widget>[
              const SettingsHeaderWidget(),
              sizedBox,
              _buildSettingsTile(
                context: context,
                text: 'Your Orders',
                icon: Icons.text_snippet_outlined,
                onTap: () {
                  context.read<RestaurantCubit>().getAllRestaurants();
                  Navigator.of(context).push(MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          const ViewOrderPage()));
                },
              ),
              sizedBox,
              _buildSettingsTile(
                context: context,
                text: 'Restaurants',
                icon: Icons.table_restaurant_outlined,
                onTap: () {
                  context.read<RestaurantCubit>().getAllRestaurants();
                  Navigator.of(context).push(MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          const AllRestaurantPage()));
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
              _buildSettingsTile(
                context: context,
                text: 'About',
                icon: Icons.info_outline_rounded,
                onTap: () {
                  Get.to(() => const AboutPage());
                },
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
                          'Logout',
                          style: TextStyles.font18BlueSemiBold,
                        ),
                        content: const Text(
                          'Are you sure you want to logout?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text(
                              'Cancel',
                              style: TextStyles.font14BlueSemiBold,
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              'Confirm',
                              style: TextStyles.font14BlueSemiBold,
                            ),
                            onPressed: () {
                              context.read<LoginCubit>().logOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      const LoginPage(),
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: <Color>[
            Colors.white,
            Colors.white70,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
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
                leading: Icon(
                  icon,
                  color: Colors.blue.shade900,
                ),
                trailing: isShowEndIcon
                    ? Icon(Icons.arrow_circle_right,
                        color: Colors.blue.shade900)
                    : null,
                title: Text(
                  text ?? '',
                  style: TextStyles.font20BlueGradienteBoldForItemsList,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
        ),
      ),
    );
  }
}
