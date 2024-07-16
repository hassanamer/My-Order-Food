import 'package:order/features/event/data/datasource/remote_order_datasource.dart';
import 'package:order/features/event/data/models/chat_model.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';

class OrderReporisatoryImlp implements OrderRepository {
  final RemoteOrderDatasourceInterface remoteOrderDatasource;

  OrderReporisatoryImlp(
    this.remoteOrderDatasource,
  );

  @override
  Future<BaseResponse> remoteAddOrders(CreateOrderEntity eventEntity) async {
    return await remoteOrderDatasource
        .remoteAddOrder(OrderModel.fromEntity(eventEntity));
  }

  @override
  Future<BaseResponse> remoteDeleteOrders() async {
    return await remoteOrderDatasource.remoteDeleteOrders();
  }

  @override
  Future<List<CreateOrderEntity>> remoteGetAllOrders() async {
    return await remoteOrderDatasource.remoteGetAllTickets();
  }

  @override
  Future<BaseResponse> remoteUpdateOrders(CreateOrderEntity eventEntity) async {
    final OrderModel orderModel = OrderModel(
        items: eventEntity.items,
        itemCount: eventEntity.items!.keys.length,
        title: eventEntity.title!,
        userId: eventEntity.userId);
    return await remoteOrderDatasource.remoteUpdateOrder(orderModel);
  }

  @override
  Future<BaseResponse> remoteUploadMessage(
      String idUser, String message, Account account) async {
    return await remoteOrderDatasource.uploadMessage(
      idUser,
      message,
      account,
    );
  }

  @override
  Future<List<ChattModel>> getMessages() async {
    return await remoteOrderDatasource.getAllMessages();
  }
}
