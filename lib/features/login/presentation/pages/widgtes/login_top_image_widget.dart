import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  const TopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FadeInUp(
          duration: const Duration(seconds: 1),
          child: Container(
            height: 209,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/login.png',
                  ),
                  fit: BoxFit.cover),
            ),
          )),
    );
  }
}
