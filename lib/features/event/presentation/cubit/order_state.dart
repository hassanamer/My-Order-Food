import 'package:order/features/event/domain/entities/order_entities.dart';

abstract class OrderState {}

class OrderStateInt extends OrderState {}

class OrderSuccessState extends OrderState {
  OrderSuccessState(ticketAdded);
}

class OrderDeletedSuccessState extends OrderState {
  OrderDeletedSuccessState(ticketDeleted);
}

class MessageAddDeleteUpdateEventState extends OrderState {
  final String message;

  MessageAddDeleteUpdateEventState({required this.message});

  List<Object> get props => [message];
}

class OrderLoadingState extends OrderState {}

class OrderLoadedState extends OrderState {
  final List<CreateOrderEntity> eventEntity;

  // List<RegisterAccountEntity> UserEntity = [];

  OrderLoadedState({required this.eventEntity});
}

class OrderErrorState extends OrderState {
  String errorMessage;

  OrderErrorState({required this.errorMessage});
}

class CommentSuccessState extends OrderState {
  CommentSuccessState(addedComment);
}

class CommentLoadedState extends OrderState {
  final List<String?> eventEntity;

  CommentLoadedState({required this.eventEntity});
}

class CommentLoadingState extends OrderState {}

class MessageSuccessState extends OrderState {
  MessageSuccessState(addedMessage);
}

class MeesageLoadedState extends OrderState {
  final List<String?> messageEntity;

  MeesageLoadedState({required this.messageEntity});
}

class MeesageLoadingState extends OrderState {}
// last

class MessageInit extends OrderState {}

class MessageLoadingState extends OrderState {}

// class MessageLoadedState extends TicketState {
//   final List<ChattModel> messages;
//   MessageLoadedState({required this.messages});
// }
