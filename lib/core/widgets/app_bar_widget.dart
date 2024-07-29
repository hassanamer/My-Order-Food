import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/notification/notification_page.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';

import '../services/notification_model.dart';
import '../services/notification_service.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? pageName;
  final Widget? titleWidget;
  final bool hideBackButton;
  final List<Widget>? actions;
  final Widget? leading;

  const AppBarWidget({
    Key? key,
    this.pageName,
    this.titleWidget,
    this.hideBackButton = true,
    this.actions,
    this.leading,
  })  : assert(pageName != null || titleWidget != null,
            'Either pageName or titleWidget must be provided'),
        super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  static bool hasNotificationNotSeen = false;
  static List<NotificationModel> notificationModels = []; // Declare here

  @override
  void initState() {
    _getNotfications();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  static _getNotfications() async {
    notificationModels = await NotificationService.getUserNotifications();
    notificationModels.map((notification) {
      if (notification.notificationNotSeenYet == false) {
        hasNotificationNotSeen = true;
      }
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _performSearch(String query, BuildContext context) {
    if (query.isEmpty) {
      BlocProvider.of<RestaurantCubit>(context).getAllRestaurants();
    } else {}
  }

  void _goToNotifications() async {
    final notifications = await NotificationService.getUserNotifications();

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new NotificationPage(),
      ),
    );

    // Navigator.of(context).pushNamed('/notifications', arguments: notifications);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.mainBlue, ColorsManager.moreLighterGray],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: widget.hideBackButton
          ? null
          : widget.leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              autofocus: true,
              onChanged: (query) => _performSearch(query, context),
            )
          : widget.titleWidget ??
              Text(
                widget.pageName!,
                style: TextStyles.font22BlackBold.copyWith(color: Colors.white),
              ),
      actions: _isSearching
          ? [
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: _stopSearch,
              ),
            ]
          : widget.actions ??
              [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startSearch,
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: _goToNotifications,
                    ),
                  ],
                ),
              ],
    );
  }
}
