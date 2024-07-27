import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class AddEventUsecase {
  final OrderRepsitory eventRepsitory;

  AddEventUsecase(this.eventRepsitory);

  Future<BaseResponse> call(OrderEntity eventEntity) async {
    return await eventRepsitory.addEvent(eventEntity);
  }
}
