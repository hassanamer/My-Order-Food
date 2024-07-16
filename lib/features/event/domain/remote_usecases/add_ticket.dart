import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

class AddTicketUsecase {
  final TicketReporisatory ticketReporisatory;
  AddTicketUsecase(this.ticketReporisatory);

  Future<BaseResponse> call(EventEntity eventEntity) async {
    return await ticketReporisatory.remoteAddTicket(eventEntity);
  }
}
