import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Login',
          style: TextStyles.font22BlackBold,
        ),
        const SizedBox(height: 8),
        Center(
          child: Column(
            children: [
              _smallParagraph(context,
                  "Chat with your friends and save your details \n for a faster checkout experince."),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  Text _smallParagraph(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyles.font16BlackSemiBold,
    );
  }
}
