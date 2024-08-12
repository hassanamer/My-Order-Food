import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class HomePageAppBarTitleWidget extends StatelessWidget {
  const HomePageAppBarTitleWidget({
    super.key,
  });

  String _greetings() {
    final int hour = TimeOfDay.now().hour;

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
      children: <Widget>[
        Text(
          'Welcome, ${_greetings()}',
          style: TextStyles.font18WhiteBold,
        ),
      ],
    );
  }
}
