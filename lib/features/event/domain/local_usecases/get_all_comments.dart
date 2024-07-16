import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class GetAllCommentsUsecase {
  final EventRepsitory eventRepsitory;

  GetAllCommentsUsecase(this.eventRepsitory);

  Future<List<CommentEntity>> call() async {
    return await eventRepsitory.getAllComment();
  }
}
