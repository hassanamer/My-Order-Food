part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final bool unseenNotifications;

  NotificationLoaded(
      {required this.notifications, required this.unseenNotifications});
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}
