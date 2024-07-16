import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/event/presentation/cubit/ticket_cubit.dart';
import 'package:order/features/event/presentation/cubit/ticket_state.dart';
import 'package:order/features/event/presentation/pages/event_page.dart';
import 'package:order/features/event/presentation/pages/widgets/event_details_page/delete_widget.dart';

class DeleteEventBtn extends StatelessWidget {
  final int eventId;
  const DeleteEventBtn({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.redAccent,
        ),
      ),
      onPressed: () => deleteDialog(context, eventId),
      icon: const Icon(Icons.delete_outline),
      label: const Text("Delete"),
    );
  }

  void deleteDialog(BuildContext context, int eventId) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<TicketCubit, TicketState>(
            listener: (context, state) {
              if (state is MessageAddDeleteUpdateEventState) {
                final snackBar = SnackBar(content: Text(state.message));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const EventPage(),
                    ),
                    (route) => false);
              } else if (state is TicketErrorState) {
                final snackBar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state is TicketLoadingState) {
                return const AlertDialog(
                  title: LoadingWidget(),
                );
              }
              return DeleteWidget(eventId: eventId);
            },
          );
        });
  }
}
