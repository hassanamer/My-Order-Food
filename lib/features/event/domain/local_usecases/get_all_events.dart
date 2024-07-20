import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class GetAllEventsUsecase {
  final EventRepsitory eventRepsitory;

  GetAllEventsUsecase(this.eventRepsitory);

  Future<List<OrderEntity>> call() async {
    return await eventRepsitory.getAllEvents();
  }
}
