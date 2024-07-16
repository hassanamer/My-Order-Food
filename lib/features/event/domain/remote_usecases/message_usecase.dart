import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';

class UploadMessageUsecase {
  final OrderRepository ticketReporisatory;

  UploadMessageUsecase(this.ticketReporisatory);

  Future<BaseResponse> call(
      String idUser, String message, Account account) async {
    return await ticketReporisatory.remoteUploadMessage(
        idUser, message, account);
  }
}
