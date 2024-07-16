import 'package:flutter/material.dart';

import '../event_add_update_pages/event_add_update_page.dart';

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
                builder: (_) => const EventAddUpdatePage(
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
