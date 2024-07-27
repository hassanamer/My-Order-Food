import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> remoteGetAllOrders();

  Future<RegisterAccountModel> remoteGetUser(String userId);

  Future<BaseResponse> remoteAddOrders(OrderEntity eventEntity);

  Future<BaseResponse> remoteUpdateOrder(OrderEntity orderEntity);

  Future<BaseResponse> remoteUpdateOrderStatus(String orderId);

  Future<BaseResponse> remoteDeleteOrders();

  Future<OrderEntity> remoteGetOrder(String orderId);
}
