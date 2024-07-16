import 'package:flutter/material.dart';

import '../event_add_update_pages/create_order_page.dart';

class FloatingButtonHomeWidget extends StatelessWidget {
  const FloatingButtonHomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CreateOrderPage(
                      isUpdateEvent: false,
                    )));
      },
      child: const Icon(
        Icons.border_color_rounded,
        color: Colors.white,
      ),
    );
  }
}
