import 'package:order/features/event/domain/entities/order_entities.dart';

import '../../../register/data/models/register_account_model.dart';

abstract class OrderRepository {
  Future<List<CreateOrderEntity>> remoteGetAllOrders();

  Future<RegisterAccountModel> remoteGetUserOrders();

  Future<BaseResponse> remoteAddOrders(CreateOrderEntity eventEntity);

  Future<BaseResponse> remoteUpdateOrders(CreateOrderEntity eventEntity);

  Future<BaseResponse> remoteDeleteOrders();
}
