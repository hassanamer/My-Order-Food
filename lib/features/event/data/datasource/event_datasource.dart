import 'package:order/core/database/database.dart';
import 'package:order/features/event/data/models/event_model.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';

abstract class EventDatasource {
  Future<List<EventEntity>> getAllEvent();
  Future<List<CommentModel>> getAllComment();
  Future<BaseResponse> deleteEvent(int id);
  Future<BaseResponse> updateEvent(EventModel eventModel, String id);
  Future<BaseResponse> addEvent(EventModel eventModel);
  Future<BaseResponse> addComment(CommentModel commentModel);
}

class EventDatasourceImpl implements EventDatasource {
  late DatabaseProvider db;

  EventDatasourceImpl(this.db);

  @override
  Future<BaseResponse> addEvent(EventModel eventModel) async {
    int value = await db.database.insert('Event', eventModel.toMap());
    try {
      if (value != 0) {
        return BaseResponse(
            status: true, message: 'Event created successfully');
      } else {
        return BaseResponse(
            status: false, message: 'Faild to create a new event');
      }
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> deleteEvent(int id) async {
    final records =
        await db.database.rawDelete('DELETE FROM Event WHERE id = \'$id\'');
    try {
      if (records >= 1) {
        return BaseResponse(
            status: true, message: 'Event deleted successfully.');
      } else {
        return BaseResponse(
            status: false, message: 'Faild to delete the event');
      }
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<List<EventEntity>> getAllEvent() async {
    List<Map<String, dynamic>> records =
        await db.database.rawQuery('select * FROM Event');
    List<EventModel> events = [];
    for (var element in records) {
      events.add(EventModel.fromMap(element));
    }

    return events;
  }

  @override
  Future<List<CommentModel>> getAllComment() async {
    List<Map<String, dynamic>> records =
        await db.database.rawQuery('select * FROM Comment');
    List<CommentModel> comments = [];
    for (var element in records) {
      comments.add(CommentModel.fromMap(element));
    }
    return comments;
  }

  @override
  Future<BaseResponse> updateEvent(EventModel eventModel, String id) async {
    final records = await db.database.update('Event', eventModel.toMap(),
        where: '$id = ?', whereArgs: [eventModel.id]);
    try {
      if (records <= 1) {
        return BaseResponse(
            status: true, message: 'Event updated successfully.');
      } else {
        return BaseResponse(
            status: false, message: 'Faild to update the event.');
      }
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> addComment(CommentModel commentModel) async {
    int value = await db.database.insert('Comment', commentModel.toMap());
    try {
      if (value != 0) {
        return BaseResponse(
            status: true, message: 'Comment created successfuly');
      } else {
        return BaseResponse(
            status: false, message: 'Faild to create the comment!');
      }
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }
}
