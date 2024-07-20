import 'package:order/features/event/domain/entities/order_entities.dart';

abstract class EventRepsitory {
  Future<List<OrderEntity>> getAllEvents();

  Future<List<CommentEntity>> getAllComment();

  Future<BaseResponse> deleteEvent(int id);

  Future<BaseResponse> updateOrder(OrderEntity eventEntity);

  Future<BaseResponse> addEvent(OrderEntity eventEntity);

  Future<BaseResponse> addComment(CommentEntity commentEntity);
}
