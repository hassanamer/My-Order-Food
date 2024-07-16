import 'package:order/features/event/data/datasource/remote_ticket_datasource.dart';
import 'package:order/features/event/data/models/event_model.dart';
import 'package:order/features/event/data/models/titcket_model.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';

class TicketReporisatoryImlp implements TicketReporisatory {
  final TicketDatasourceInterface remoteTicketDatasource;

  TicketReporisatoryImlp(
    this.remoteTicketDatasource,
  );

  @override
  Future<BaseResponse> remoteAddTicket(EventEntity eventEntity) async {
    return await remoteTicketDatasource
        .remoteAddTicket(EventModel.fromEntity(eventEntity));
  }

  @override
  Future<BaseResponse> remoteDeleteTicket() async {
    return await remoteTicketDatasource.remoteDeleteTicket();
  }

  @override
  Future<List<EventEntity>> remoteGetAllTickets() async {
    return await remoteTicketDatasource.remoteGetAllTickets();
  }

  @override
  Future<BaseResponse> remoteUpdateTicket(EventEntity eventEntity) async {
    final EventModel eventModel = EventModel(
      title: eventEntity.title!,
      item: eventEntity.item!,
    );
    return await remoteTicketDatasource.remoteUpdateTicket(eventModel);
  }

  @override
  Future<BaseResponse> remoteUploadMessage(
      String idUser, String message, Account account) async {
    return await remoteTicketDatasource.uploadMessage(
      idUser,
      message,
      account,
    );
  }

  @override
  Future<List<ChattModel>> getMessages() async {
    return await remoteTicketDatasource.getAllMessages();
  }
}
