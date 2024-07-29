import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class HomePageAppBarTitleWidget extends StatelessWidget {
  const HomePageAppBarTitleWidget({
    Key? key,
  }) : super(key: key);

  String _greetings() {
    final hour = TimeOfDay.now().hour;

    if (hour <= 12) {
      return 'Good Morning';
    } else if (hour <= 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Welcome, ${_greetings()}',
          style: TextStyles.font18WhiteBold,
        ),
      ],
    );
  }
}
