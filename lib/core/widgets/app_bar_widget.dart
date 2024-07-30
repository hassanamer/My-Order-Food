import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/notification/notification_page.dart';

import '../services/notification_cubit.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _goToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
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
      title: widget.titleWidget ??
          Text(
            widget.pageName!,
            style: TextStyles.font22BlackBold.copyWith(color: Colors.white),
          ),
      actions: widget.actions ??
          [
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                bool hasUnseenNotifications = false;

                if (state is NotificationLoaded) {
                  hasUnseenNotifications = state.unseenNotifications;
                }
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: _goToNotifications,
                    ),
                    if (hasUnseenNotifications)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
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
