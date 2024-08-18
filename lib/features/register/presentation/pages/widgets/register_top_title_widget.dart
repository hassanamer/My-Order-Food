import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';

class RegisterTopTitleWidget extends StatelessWidget {
  const RegisterTopTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
      child:
          const Text('Create a new account', style: TextStyles.font27WhiteBold),
    );
  }
}
