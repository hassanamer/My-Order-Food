import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/reporisatory/event_reprisatory.dart';

class CommentOnEventUsecase {
  final EventRepsitory eventRepsitory;

  CommentOnEventUsecase(this.eventRepsitory);

  Future<BaseResponse> call(CommentEntity commentEntity) async {
    return await eventRepsitory.addComment(commentEntity);
  }
}
