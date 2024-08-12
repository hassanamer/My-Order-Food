import 'package:flutter/material.dart';
import 'package:order/features/event/presentation/pages/widgets/create_order_pages/create_order_page.dart';

class FloatingButtonHomeWidget extends StatelessWidget {
  const FloatingButtonHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
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
