import 'package:flutter/material.dart';

import 'header_container_add_restaurant_widget.dart';

class AddMenuButtonWidget extends StatelessWidget {
  const AddMenuButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        const UnderlineTextWidget(text: "Now add the menu"),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              side: const BorderSide(color: Color.fromARGB(255, 207, 78, 27))),
          onPressed: onTap,
          child: const Text('Add menu'),
        ),
      ],
    );
  }
}
