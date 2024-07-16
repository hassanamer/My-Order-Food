import 'package:order/features/event/domain/entities/event_entities.dart';

abstract class TicketState {}

class TicketStateInt extends TicketState {}

class TicketSuccessState extends TicketState {
  TicketSuccessState(ticketAdded);
}

class TicketDeletedSuccessState extends TicketState {
  TicketDeletedSuccessState(ticketDeleted);
}

class MessageAddDeleteUpdateEventState extends TicketState {
  final String message;

  MessageAddDeleteUpdateEventState({required this.message});
  List<Object> get props => [message];
}

class TicketLoadingState extends TicketState {}

class TicketLoadedState extends TicketState {
  final List<EventEntity> eventEntity;
  TicketLoadedState({required this.eventEntity});
}

class TicketErrorState extends TicketState {
  String errorMessage;
  TicketErrorState({required this.errorMessage});
}

class CommentSuccessState extends TicketState {
  CommentSuccessState(addedComment);
}

class CommentLoadedState extends TicketState {
  final List<String?> eventEntity;

  CommentLoadedState({required this.eventEntity});
}

class CommentLoadingState extends TicketState {}

class MessageSuccessState extends TicketState {
  MessageSuccessState(addedMessage);
}

class MeesageLoadedState extends TicketState {
  final List<String?> messageEntity;

  MeesageLoadedState({required this.messageEntity});
}

class MeesageLoadingState extends TicketState {}
// last

class MessageInit extends TicketState {}

class MessageLoadingState extends TicketState {}

// class MessageLoadedState extends TicketState {
//   final List<ChattModel> messages;
//   MessageLoadedState({required this.messages});
// }