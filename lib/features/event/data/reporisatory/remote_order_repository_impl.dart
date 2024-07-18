import 'package:order/features/event/data/datasource/remote_order_datasource.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';

import '../../../register/data/models/register_account_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final RemoteOrderDatasourceInterface remoteOrderDatasource;

  OrderRepositoryImpl(this.remoteOrderDatasource);

  @override
  Future<BaseResponse> remoteAddOrders(CreateOrderEntity eventEntity) async {
    return await remoteOrderDatasource
        .addOrder(OrderModel.fromEntity(eventEntity));
  }

  @override
  Future<BaseResponse> remoteDeleteOrders() async {
    return await remoteOrderDatasource.deleteOrders();
  }

  @override
  Future<List<CreateOrderEntity>> remoteGetAllOrders() async {
    return await remoteOrderDatasource.getAllOrders();
  }

  @override
  Future<BaseResponse> remoteUpdateOrders(CreateOrderEntity eventEntity) async {
    final OrderModel orderModel = OrderModel(
      items: eventEntity.items,
      title: eventEntity.title,
      userId: eventEntity.userId,
      id: eventEntity.id,
    );
    return await remoteOrderDatasource.updateOrder(orderModel);
  }

  @override
  Future<RegisterAccountModel> remoteGetUserOrders() async {
    return await remoteOrderDatasource.getUserOrders();
  }
}
