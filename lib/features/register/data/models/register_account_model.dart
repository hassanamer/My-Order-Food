// ignore_for_file: always_specify_types

import 'package:order/features/register/domain/entities/register_entities.dart';

class RegisterAccountModel extends RegisterAccountEntity {
  RegisterAccountModel({
    super.userId,
    super.username,
    super.name,
    super.email,
    super.phoneNumber,
    super.profileImageUrl,
    super.gender,
    super.message,
    super.replyCode,
    super.fcmToken,
    super.hasCar,
    super.deliveryPreference,
    super.placedOrderCount,
    super.receivedOrderCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': username,
      'name': name,
      'email': email,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'fcmToken': fcmToken,
      'hasCar': hasCar,
      'deliveryPreference': deliveryPreference,
      'receivedOrderCount': receivedOrderCount,
      'placedOrderCount': placedOrderCount,
    };
  }

  factory RegisterAccountModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return RegisterAccountModel();
    }
    return RegisterAccountModel(
      userId: map['userId'] ?? '',
      username: map['userName'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      fcmToken: map['fcmToken'],
      hasCar: map['hasCar'],
      deliveryPreference: map['deliveryPreference'],
      placedOrderCount: map['placedOrderCount'],
      receivedOrderCount: map['receivedOrderCount'],
    );
  }

  Future<void> incrementPlacedOrderCount() async {
    placedOrderCount = (placedOrderCount ?? 0) + 1;
  }

  Future<void> incrementReceivedOrderCount() async {
    receivedOrderCount = (receivedOrderCount ?? 0) + 1;
  }
}
