import 'package:order/features/event/data/models/titcket_model.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class GetMessagesUsecase {
  final TicketReporisatory ticketReporisatory;
  GetMessagesUsecase(this.ticketReporisatory);

  Future<List<ChattModel>> call() async {
    return await ticketReporisatory.getMessages();
  }
}
