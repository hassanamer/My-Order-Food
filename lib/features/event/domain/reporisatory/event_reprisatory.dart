import 'package:order/features/event/domain/entities/event_entities.dart';

abstract class EventRepsitory {
  Future<List<EventEntity>> getAllEvents();
  Future<List<CommentEntity>> getAllComment();
  Future<BaseResponse> deleteEvent(int id);
  Future<BaseResponse> updateEvent(EventEntity eventEntity);
  Future<BaseResponse> addEvent(EventEntity eventEntity);
  Future<BaseResponse> addComment(CommentEntity commentEntity);
}
