import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';
import 'package:order/core/widgets/loading_widget.dart';
import 'package:order/features/notification/data/datasources/push_notification_service.dart';
import 'package:order/features/notification/data/model/notification_model.dart';
import 'package:order/features/notification/presentation/cubit/notification_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Stream<List<NotificationModel>> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _notificationsStream =
        PushNotificationService.currentUserNotificationsStream();
    context.read<NotificationCubit>().markAllNotificationsAsSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      appBar: const AppBarWidget(
        pageName: 'Notifications',
        hideNotificationIcon: true,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationsStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<NotificationModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          final DateTime now = DateTime.now();
          final DateTime fiveDaysAgo = now.subtract(const Duration(days: 5));

          final List<NotificationModel> recentNotifications = snapshot.data!
              .where(
                  (notification) => notification.timestamp.isAfter(fiveDaysAgo))
              .toList();

          if (recentNotifications.isEmpty) {
            return const Center(
                child: Text('No notifications from the past 5 days'));
          }

          return ListView.builder(
            itemCount: recentNotifications.length,
            itemBuilder: (BuildContext context, int index) {
              final NotificationModel notification = recentNotifications[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Colors.white,
                        Colors.white70,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    title: Text(notification.title,
                        style: TextStyles.font18BlueGradienteBoldForItemsList),
                    subtitle: Text(notification.message,
                        style: TextStyles.font14BlueGradienteBoldForItemsList),
                    trailing: Text(_formatTimestamp(notification.timestamp),
                        style: TextStyles.font14BlueGradienteBoldForItemsList),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(timestamp);

    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
