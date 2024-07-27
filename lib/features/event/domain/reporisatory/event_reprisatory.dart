import 'package:order/features/event/domain/entities/order_entities.dart';

abstract class OrderRepsitory {
  Future<List<OrderEntity>> getAllEvents();

  Future<BaseResponse> deleteEvent(int id);

  Future<BaseResponse> updateOrder(OrderEntity eventEntity);

  Future<BaseResponse> addEvent(OrderEntity eventEntity);
}
