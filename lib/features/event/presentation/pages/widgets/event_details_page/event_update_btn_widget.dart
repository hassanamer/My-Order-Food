import 'package:flutter/material.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/event_add_update_pages/event_add_update_page.dart';

class UpdateBtnWidget extends StatelessWidget {
  final EventEntity eventEntity;
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
              builder: (_) => EventAddUpdatePage(
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
