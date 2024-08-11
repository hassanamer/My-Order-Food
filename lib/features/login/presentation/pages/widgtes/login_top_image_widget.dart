import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  const TopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FadeInUp(
          duration: Duration(seconds: 1),
          child: Container(
            height: 205,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/login.png',
                ),
              ),
            ),
          )),
    );
  }
}
