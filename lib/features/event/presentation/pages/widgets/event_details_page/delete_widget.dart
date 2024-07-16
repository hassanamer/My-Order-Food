import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/presentation/cubit/ticket_cubit.dart';

class DeleteWidget extends StatelessWidget {
  final int eventId;
  const DeleteWidget({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<TicketCubit>(context).deleteTicket();
          },
          child: const Text('yes'),
        ),
      ],
    );
  }
}
