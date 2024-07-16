import 'package:order/features/event/data/datasource/order_datasource.dart';
import 'package:order/features/event/data/models/order_model.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class EventReporisatoryImpl implements EventRepsitory {
  final OrderDataSourceImpl orderDatasourceImpl;

  EventReporisatoryImpl(this.orderDatasourceImpl);

  @override
  Future<BaseResponse> addEvent(CreateOrderEntity eventEntity) async {
    return await orderDatasourceImpl
        .addEvent(OrderModel.fromEntity(eventEntity));
  }

  @override
  Future<BaseResponse> deleteEvent(int id) async {
    return await orderDatasourceImpl.deleteEvent(id);
  }

  @override
  Future<List<CreateOrderEntity>> getAllEvents() async {
    return await orderDatasourceImpl.getAllEvent();
  }

  @override
  Future<List<CommentEntity>> getAllComment() async {
    return await orderDatasourceImpl.getAllComment();
  }

  @override
  Future<BaseResponse> updateOrder(CreateOrderEntity orderEntity) async {
    final OrderModel orderModel = OrderModel(
      userId: orderEntity.userId,
      id: orderEntity.id,
      title: orderEntity.title,
    );
    return await orderDatasourceImpl.updateOrder(orderModel, 'id');
  }

  @override
  Future<BaseResponse> addComment(CommentEntity commentEntity) async {
    return await orderDatasourceImpl
        .addComment(CommentModel.fromEntity(commentEntity));
  }
}
