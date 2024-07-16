import 'package:order/features/event/domain/entities/order_entities.dart';

abstract class EventRepsitory {
  Future<List<CreateOrderEntity>> getAllEvents();

  Future<List<CommentEntity>> getAllComment();

  Future<BaseResponse> deleteEvent(int id);

  Future<BaseResponse> updateOrder(CreateOrderEntity eventEntity);

  Future<BaseResponse> addEvent(CreateOrderEntity eventEntity);

  Future<BaseResponse> addComment(CommentEntity commentEntity);
}
