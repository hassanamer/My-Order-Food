import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:order/features/notification/presentation/pages/notification_page.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? pageName;
  final String? pageDescreption;
  final Widget? titleWidget;
  final bool hideBackButton;
  final bool hideNotificationIcon;
  final List<Widget>? actions;
  final Widget? leading;

  const AppBarWidget({
    super.key,
    this.pageName,
    this.pageDescreption,
    this.titleWidget,
    this.hideBackButton = true,
    this.actions,
    this.leading,
    this.hideNotificationIcon = false,
  }) : assert(pageName != null || titleWidget != null,
            'Either pageName or titleWidget must be provided');

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _goToNotifications() {
    Navigator.of(context).push(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const NotificationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              ColorsManager.mainBlue,
              ColorsManager.moreLighterGray
            ],
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
      title: Column(
        children: <Widget>[
          widget.titleWidget ??
              Text(
                widget.pageName!,
                style: TextStyles.font22WhiteBold.copyWith(color: Colors.white),
              ),
          Text(
            widget.pageDescreption ?? '',
            style: TextStyles.font14DarkBlueMedium,
          ),
        ],
      ),
      actions: widget.hideNotificationIcon
          ? null
          : widget.actions ??
              <Widget>[
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (BuildContext context, NotificationState state) {
                    bool hasUnseenNotifications = false;

                    if (state is NotificationLoaded) {
                      hasUnseenNotifications = state.unseenNotifications;
                    }
                    return Stack(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: _goToNotifications,
                        ),
                        if (hasUnseenNotifications)
                          Positioned(
                            right: 7,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: const Center(
                                child: Text(
                                  '!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
    );
  }
}
