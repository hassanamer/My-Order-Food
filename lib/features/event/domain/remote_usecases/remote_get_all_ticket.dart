import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class GetAllTicketUsecase {
  final TicketReporisatory ticketReporisatory;
  GetAllTicketUsecase(this.ticketReporisatory);

  Future<List<EventEntity>> call() async {
    return await ticketReporisatory.remoteGetAllTickets();
  }
}
