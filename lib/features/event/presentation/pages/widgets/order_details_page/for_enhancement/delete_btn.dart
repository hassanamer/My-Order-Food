

// class DeleteEventBtn extends StatelessWidget {
//   final int eventId;
//
//   const DeleteEventBtn({
//     Key? key,
//     required this.eventId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(
//           Colors.redAccent,
//         ),
//       ),
//       // onPressed: () => deleteDialog(context, eventId),
//       icon: const Icon(Icons.delete_outline),
//       label: const Text("Delete"),
//     );
//   }
//
//   void deleteDialog(BuildContext context, int eventId) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return BlocConsumer<OrderCubit, OrderState>(
//             listener: (context, state) {
//               if (state is MessageAddDeleteUpdateEventState) {
//                 final snackBar = SnackBar(content: Text(state.message));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                       builder: (_) => const EventPage(),
//                     ),
//                     (route) => false);
//               } else if (state is OrderErrorState) {
//                 final snackBar = SnackBar(content: Text(state.errorMessage));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               }
//             },
//             builder: (context, state) {
//               if (state is OrderLoadingState) {
//                 return const AlertDialog(
//                   title: LoadingWidget(),
//                 );
//               }
//               return DeleteWidget(eventId: eventId);
//             },
//           );
//         });
//   }
// }
