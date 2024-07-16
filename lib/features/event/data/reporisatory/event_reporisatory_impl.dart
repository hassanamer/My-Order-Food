import 'package:order/features/event/data/datasource/event_datasource.dart';
import 'package:order/features/event/data/models/event_model.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class EventReporisatoryImpl implements EventRepsitory {
  final EventDatasourceImpl eventDatasourceImpl;

  EventReporisatoryImpl(this.eventDatasourceImpl);

  @override
  Future<BaseResponse> addEvent(EventEntity eventEntity) async {
    return await eventDatasourceImpl
        .addEvent(EventModel.fromEntity(eventEntity));
  }

  @override
  Future<BaseResponse> deleteEvent(int id) async {
    return await eventDatasourceImpl.deleteEvent(id);
  }

  @override
  Future<List<EventEntity>> getAllEvents() async {
    return await eventDatasourceImpl.getAllEvent();
  }

  @override
  Future<List<CommentEntity>> getAllComment() async {
    return await eventDatasourceImpl.getAllComment();
  }

  @override
  Future<BaseResponse> updateEvent(EventEntity eventEntity) async {
    final EventModel eventModel = EventModel(
        id: eventEntity.id,
        title: eventEntity.title,

        item: eventEntity.item);
    return await eventDatasourceImpl.updateEvent(eventModel, 'id');
  }

  @override
  Future<BaseResponse> addComment(CommentEntity commentEntity) async {
    return await eventDatasourceImpl
        .addComment(CommentModel.fromEntity(commentEntity));
  }
}
