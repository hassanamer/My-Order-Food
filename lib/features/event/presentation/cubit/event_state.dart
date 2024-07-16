import 'package:order/features/event/domain/entities/event_entities.dart';

abstract class EventState {}

class EventSuccessState extends EventState {
  EventSuccessState(addedEvent);
}

class EventLoadedState extends EventState {
  final List<EventEntity> eventEntity;

  EventLoadedState({required this.eventEntity});
}

class CommentSuccessState extends EventState {
  CommentSuccessState(addedComment);
}

class CommentLoadedState extends EventState {
  final List<CommentEntity> commentEntity;

  CommentLoadedState({required this.commentEntity});
}

class MessageAddDeleteUpdateEventState extends EventState {
  final String message;

  MessageAddDeleteUpdateEventState({required this.message});
  List<Object> get props => [message];
}

class EventErrorState extends EventState {
  String errorMessage;

  EventErrorState({required this.errorMessage});
}

class EventStateInt extends EventState {}

class DeleteEvent extends EventState {
  final int eventId;

  DeleteEvent(this.eventId);
}

class RefreshEvents extends EventState {}

class EventLoadingState extends EventState {}

class CommentLoadingState extends EventState {}
