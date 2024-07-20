import 'package:order/features/event/data/datasource/remote_order_datasource.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final RemoteOrderDatasourceInterface remoteOrderDatasource;

  OrderRepositoryImpl(this.remoteOrderDatasource);

  @override
  Future<BaseResponse> remoteAddOrders(OrderEntity eventEntity) async {
    return await remoteOrderDatasource
        .addOrder(OrderModel.fromEntity(eventEntity));
  }

  @override
  Future<BaseResponse> remoteDeleteOrders() async {
    return await remoteOrderDatasource.deleteOrders();
  }

  @override
  Future<List<OrderEntity>> remoteGetAllOrders() async {
    return await remoteOrderDatasource.getAllOrders();
  }

  @override
  Future<BaseResponse> remoteUpdateOrder(OrderEntity orderEntity) async {
    final OrderModel orderModel = orderEntity.toOrderModel();

    return await remoteOrderDatasource.updateOrder(orderModel);
  }

  @override
  Future<RegisterAccountModel> remoteGetUser(String userId) async {
    return await remoteOrderDatasource.getUser(userId);
  }
}
