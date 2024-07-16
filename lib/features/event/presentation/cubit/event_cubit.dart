import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/features/event/domain/entities/event_entities.dart';
import 'package:order/features/event/domain/local_usecases/add_event.dart';
import 'package:order/features/event/domain/local_usecases/comment_on_event_usecase.dart';
import 'package:order/features/event/domain/local_usecases/delete_event.dart';
import 'package:order/features/event/domain/local_usecases/get_all_comments.dart';
import 'package:order/features/event/domain/local_usecases/get_all_events.dart';
import 'package:order/features/event/domain/local_usecases/update_event.dart';
import 'package:order/features/event/presentation/cubit/event_state.dart';
import 'package:order/injection_container.dart';

class EventCubit extends Cubit<EventState> {
  late AddEventUsecase addEventUsecase;
  late DeleteEventUsecase deleteEventUsecase;
  late GetAllEventsUsecase getAllEventsUsecase;
  late GetAllCommentsUsecase getAllCommentsUsecase;
  late UpdateEventUsecase updateEventUsecase;
  late CommentOnEventUsecase commentOnEventUsecase;
  EventCubit(
      // required this.addEventUsecase,
      // required this.commentOnEventUsecase,
      // required this.deleteEventUsecase,
      // required this.getAllEventsUsecase,
      // required this.getAllCommentsUsecase,
      // required this.updateEventUsecase,
      )
      : super(EventStateInt());

  Future<void> addComment(CommentEntity commentEntity) async {
    try {
      emit(EventLoadingState());
      commentOnEventUsecase = sl();
      final addedComment = await commentOnEventUsecase.call(commentEntity);
      if (addedComment.status) {
        emit(CommentSuccessState(addedComment));
        final allComment = await getAllCommentsUsecase.call();
        emit(CommentLoadedState(commentEntity: allComment));
      } else {
        emit(EventErrorState(errorMessage: addedComment.message));
      }
    } catch (e) {
      emit(EventErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> addEvent(EventEntity eventEntity) async {
    try {
      emit(EventLoadingState());
      addEventUsecase = sl();
      final addedEvent = await addEventUsecase.call(eventEntity);
      if (addedEvent.status) {
        emit(EventSuccessState(addedEvent));
        final allEvent = await getAllEventsUsecase.call();
        emit(EventLoadedState(eventEntity: allEvent));
      } else {
        emit(EventErrorState(errorMessage: addedEvent.message));
      }
    } catch (e) {
      emit(EventErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> deleteEvent(eventId) async {
    try {
      emit(EventLoadingState());
      deleteEventUsecase = sl();
      final deletedEvent = await deleteEventUsecase.call(eventId);
      if (deletedEvent.status) {
        emit(EventSuccessState(deletedEvent));
      } else {
        emit(EventErrorState(errorMessage: deletedEvent.message));
      }
    } catch (e) {
      emit(EventErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> getAllEvents() async {
    try {
      emit(EventLoadingState());
      getAllEventsUsecase = sl();
      final allEvent = await getAllEventsUsecase.call();
      emit(EventLoadedState(eventEntity: allEvent));
    } catch (e) {
      emit(EventErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> getAllComments() async {
    try {
      emit(EventLoadingState());
      getAllCommentsUsecase = sl();
      final allComment = await getAllCommentsUsecase.call();
      emit(CommentLoadedState(commentEntity: allComment));
    } catch (e) {
      emit(EventErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> updateEvent(EventEntity eventEntity) async {
    try {
      emit(EventLoadingState());
      updateEventUsecase = sl();
      final updatedEvent = await updateEventUsecase.call(eventEntity);
      if (updatedEvent.status) {
        emit(EventSuccessState(updatedEvent));
      } else {
        emit(EventErrorState(errorMessage: updatedEvent.message));
      }
    } catch (e) {
      emit(EventErrorState(errorMessage: e.toString()));
    }
  }
}
