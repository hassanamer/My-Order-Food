import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class DeleteEventUsecase {
  final EventRepsitory eventRepsitory;

  DeleteEventUsecase(this.eventRepsitory);

  Future<BaseResponse> call(int eventId) async {
    return await eventRepsitory.deleteEvent(eventId);
  }
}
