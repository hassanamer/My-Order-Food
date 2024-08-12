import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';

class DeleteWidget extends StatelessWidget {
  final int eventId;

  const DeleteWidget({
    required this.eventId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<OrderCubit>(context).deleteOrder();
          },
          child: const Text('yes'),
        ),
      ],
    );
  }
}
