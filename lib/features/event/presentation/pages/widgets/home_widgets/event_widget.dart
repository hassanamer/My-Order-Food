import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/event_details_page/event_detail_page.dart';

class EventWidget extends StatelessWidget {
  final List<CreateOrderEntity> eventEntity;

  const EventWidget({
    Key? key,
    required this.eventEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: eventEntity.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(eventEntity[index].id.toString()),
          title: Text(
            eventEntity[index].title!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text(
          //   eventEntity[index].ii!,
          // style: const TextStyle(fontSize: 16),
          // ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          onTap: () {
            Get.to(EventDetailsPage(
              eventEntity: eventEntity[index],
            ));
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(thickness: 1),
    );
  }
}
