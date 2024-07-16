import 'package:order/features/event/data/models/titcket_model.dart';

abstract class ChatState {}

class ChatStateInt extends ChatState {}

class ChatErrorState extends ChatState {
  String errorMessage;
  ChatErrorState({required this.errorMessage});
}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<ChattModel> messages;
  ChatLoadedState({required this.messages});
}
