import 'package:order/core/database/database.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';

abstract class OrderDataSource {
  Future<List<OrderEntity>> getAllEvent();

  Future<List<CommentModel>> getAllComment();

  Future<BaseResponse> deleteEvent(int id);

  Future<BaseResponse> updateOrder(OrderModel eventModel, String id);

  Future<BaseResponse> addEvent(OrderModel eventModel);

  Future<BaseResponse> addComment(CommentModel commentModel);
}

class OrderDataSourceImpl implements OrderDataSource {
  late DatabaseProvider db;

  OrderDataSourceImpl(this.db);

  @override
  Future<BaseResponse> addEvent(OrderModel eventModel) async {
    int value = await db.database.insert('Event', eventModel.toMap());
    try {
      if (value != 0) {
        return BaseResponse(status: true, message: 'Orde created successfully');
      } else {
        return BaseResponse(
            status: false, message: 'Faild to create a new order');
      }
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<BaseResponse> deleteEvent(int id) async {
    final records =
        await db.database.rawDelete('DELETE FROM Order WHERE id = \'$id\'');
    try {
      if (records >= 1) {
        return BaseResponse(
            status: true, message: 'Order deleted successfully.');
      } else {
        return BaseResponse(
            status: false, message: 'Faild to delete the event');
      }
    } catch (e) {
      return BaseResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<List<OrderEntity>> getAllEvent() async {
    List<Map<String, dynamic>> records =
        await db.database.rawQuery('select * FROM Event');
    List<OrderModel> events = [];
    for (var element in records) {
      events.add(OrderModel.fromMap(element));
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
  Future<BaseResponse> updateOrder(OrderModel orderModel, String id) async {
    final records = await db.database.update('Event', orderModel.toMap(),
        where: '$id = ?', whereArgs: [orderModel.id]);
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
