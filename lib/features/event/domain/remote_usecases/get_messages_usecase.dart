import 'package:order/features/event/data/models/chat_model.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class GetMessagesUsecase {
  final OrderRepository ticketReporisatory;

  GetMessagesUsecase(this.ticketReporisatory);

  Future<List<ChattModel>> call() async {
    return await ticketReporisatory.getMessages();
  }
}
