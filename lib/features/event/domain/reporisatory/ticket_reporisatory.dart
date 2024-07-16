import 'package:order/features/event/data/models/chat_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';

abstract class OrderRepository {
  Future<List<CreateOrderEntity>> remoteGetAllOrders();

  Future<BaseResponse> remoteAddOrders(CreateOrderEntity eventEntity);

  Future<BaseResponse> remoteUpdateOrders(CreateOrderEntity eventEntity);

  Future<BaseResponse> remoteDeleteOrders();

  Future<BaseResponse> remoteUploadMessage(
      String idUser, String message, Account account);

  Future<List<ChattModel>> getMessages();
}
