import 'package:flutter_neumorphic/flutter_neumorphic.dart';

enum OrderStatusEnum {
  active(
      title: 'Active',
      color: Colors.yellow,
      icon: Icons.hourglass_top_outlined,
      descreption: 'This Order Is Active'),
  placed(
      title: 'Placed',
      color: Colors.blue,
      icon: Icons.local_shipping_outlined,
      descreption: 'This order is on it\'s way to you.'),
  arrived(
      title: 'Arrived',
      color: Colors.white,
      icon: Icons.task_alt_outlined,
      descreption: 'Thank you for ordered with us.'),
  cancelled(
      title: 'Cancelled',
      color: Colors.red,
      icon: Icons.cancel_outlined,
      descreption:
          'No One Joined This Order SO Unforgettably \n It Was Cancelled.');

  final String title;
  final String descreption;
  final IconData icon;
  final Color color;

  const OrderStatusEnum({
    required this.title,
    required this.descreption,
    required this.icon,
    required this.color,
  });

  String get name {
    switch (this) {
      case OrderStatusEnum.active:
        return 'Active';
      case OrderStatusEnum.placed:
        return 'Placed';
      case OrderStatusEnum.arrived:
        return 'Arrived';
      case OrderStatusEnum.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }

  static Color getStatusColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.active:
        return Colors.white;
      case OrderStatusEnum.placed:
        return Colors.white;
      case OrderStatusEnum.arrived:
        return Colors.white;
      case OrderStatusEnum.cancelled:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
