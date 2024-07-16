import 'package:flutter/material.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
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
      leading: hideBackButton
          ? null
          : leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
      title: titleWidget ??
          Text(
            pageName!,
            style: TextStyles.font22BlackBold.copyWith(color: Colors.white),
          ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Add search functionality here
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add notification functionality here
              },
            ),
          ],
    );
  }
}
