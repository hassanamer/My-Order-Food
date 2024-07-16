import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class DeleteTicketUsecase {
  final TicketReporisatory ticketReporisatory;
  DeleteTicketUsecase(this.ticketReporisatory);

  Future<BaseResponse> call() async {
    return await ticketReporisatory.remoteDeleteTicket();
  }
}
