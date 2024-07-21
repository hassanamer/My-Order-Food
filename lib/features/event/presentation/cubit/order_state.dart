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
  final List<OrderEntity> orderEntity;

  // List<RegisterAccountEntity> UserEntity = [];

  OrderLoadedState({required this.orderEntity});
}

class OrderErrorState extends OrderState {
  String errorMessage;

  OrderErrorState({required this.errorMessage});
}
