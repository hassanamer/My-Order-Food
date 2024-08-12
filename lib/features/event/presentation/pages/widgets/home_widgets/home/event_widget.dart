import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/presentation/pages/widgets/order_details_page/order_details_page.dart';

class EventWidget extends StatelessWidget {
  final List<OrderEntity> eventEntity;

  const EventWidget({
    required this.eventEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: eventEntity.length,
      itemBuilder: (BuildContext context, int index) {
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
            Get.to(OrderDetailsPage(
              orderEntity: eventEntity[index],
            ));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(thickness: 1),
    );
  }
}
