import 'package:order/features/event/data/models/titcket_model.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';

abstract class TicketReporisatory {
  Future<List<EventEntity>> remoteGetAllTickets();
  Future<BaseResponse> remoteAddTicket(EventEntity eventEntity);
  Future<BaseResponse> remoteUpdateTicket(EventEntity eventEntity);
  Future<BaseResponse> remoteDeleteTicket();
  Future<BaseResponse> remoteUploadMessage(
      String idUser, String message, Account account);
  Future<List<ChattModel>> getMessages();
}
