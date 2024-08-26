import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Login',
          style: TextStyles.font34WhiteBold,
        ),
        const SizedBox(height: 8),
        Center(
          child: Column(
            children: <Widget>[
              _smallParagraph(context,
                  'Chat with your friends and save your details for a faster checkout experince.'),
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
      style: TextStyles.font20WhiteBold,
    );
  }
}
