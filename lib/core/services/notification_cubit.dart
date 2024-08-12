import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order/core/services/notification_model.dart';
import 'package:order/core/services/notification_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    loadNotifications(); // Ensure notifications are loaded initially
  }

  void loadNotifications() async {
    emit(NotificationLoading());
    try {
      await for (final List<NotificationModel> notifications
          in NotificationService.currentUserNotificationsStream()) {
        bool unseenNotifications = notifications.any(
            (NotificationModel notification) => !notification.notificationSeen);
        emit(NotificationLoaded(
            notifications: notifications,
            unseenNotifications: unseenNotifications));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> markAllNotificationsAsSeen() async {
    final NotificationState state = this.state;
    if (state is NotificationLoaded) {
      for (NotificationModel notification in state.notifications) {
        if (!notification.notificationSeen) {
          notification.notificationSeen = true;
          await NotificationService.updateNotification(notification);
        }
      }
      emit(NotificationLoaded(
        notifications: state.notifications,
        unseenNotifications: false,
      ));
    }
  }
}
