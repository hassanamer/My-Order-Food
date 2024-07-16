import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class AddEventUsecase {
  final EventRepsitory eventRepsitory;

  AddEventUsecase(this.eventRepsitory);

  Future<BaseResponse> call(EventEntity eventEntity) async {
    return await eventRepsitory.addEvent(eventEntity);
  }
}
