import 'package:flutter/material.dart';

class RegisterTopTitleWidget extends StatelessWidget {
  const RegisterTopTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
      child: Text(
        'Creat a new account',
        style: TextStyle(
            color: Theme.of(context).textTheme.displayLarge!.color,
            fontSize: 26,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
