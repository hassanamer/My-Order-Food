import 'package:order/features/event/domain/entities/order_entities.dart';

abstract class OrderRepository {
  Future<List<CreateOrderEntity>> remoteGetAllOrders();

  Future<BaseResponse> remoteAddOrders(CreateOrderEntity eventEntity);

  Future<BaseResponse> remoteUpdateOrders(CreateOrderEntity eventEntity);

  Future<BaseResponse> remoteDeleteOrders();
}
