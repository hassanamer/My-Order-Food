import 'package:flutter/material.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/create_order_pages/create_order_page.dart';

class UpdateBtnWidget extends StatelessWidget {
  final OrderEntity eventEntity;

  const UpdateBtnWidget({
    Key? key,
    required this.eventEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateOrderPage(
                isUpdateEvent: true,
                eventEntity: eventEntity,
              ),
            ));
      },
      icon: const Icon(Icons.edit),
      label: const Text("Edit"),
    );
  }
}
