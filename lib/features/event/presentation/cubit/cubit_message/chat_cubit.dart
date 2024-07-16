import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/domain/remote_usecases/get_messages_usecase.dart';
import 'package:order/features/event/presentation/cubit/cubit_message/chat_state.dart';
import 'package:order/injection_container.dart';

class ChatCubit extends Cubit<ChatState> {
  late GetMessagesUsecase getMessagesUsecase;
  ChatCubit() : super(ChatStateInt());

  Future<void> getChatData() async {
    try {
      getMessagesUsecase = sl();
      final allMessages = await getMessagesUsecase.call();
      emit(ChatLoadedState(messages: allMessages));
    } catch (e) {
      emit(ChatErrorState(errorMessage: e.toString()));
    }
  }
}
