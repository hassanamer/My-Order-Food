import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order/core/theming/styles.dart';

class HomePageAppBarTitleWidget extends StatelessWidget {
  const HomePageAppBarTitleWidget({
    super.key,
  });

  String _greetings() {
    final int hour = TimeOfDay.now().hour;

    if (hour <= 12) {
      return 'Good Morning!';
    } else if (hour <= 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  String _currentDate() {
    return DateFormat('EEEE, MMMM d').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Text(
                'Welcome, ${_greetings()}',
                style: TextStyles.font18WhiteBold,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            _currentDate(),
            style: TextStyles
                .font16WhiteSemiBold, // You can customize this text style
          ),
        ],
      ),
    );
  }
}
