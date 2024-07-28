import '../../domain/entities/register_entities.dart';

class RegisterAccountModel extends RegisterAccountEntity {
  RegisterAccountModel({
    String? userId,
    String? username,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? gender,
    String? message,
    int? replyCode,
    String? fcmToken,
    String? hasCar,
    String? deliveryPreference,
    int? placedOrderCount = 0,
    int? receivedOrderCount = 0,
  }) : super(
          userId: userId,
          username: username,
          email: email,
          profileImageUrl: profileImageUrl,
          gender: gender,
          name: name,
          phoneNumber: phoneNumber,
          message: message,
          replyCode: replyCode,
          fcmToken: fcmToken,
          hasCar: hasCar,
          deliveryPreference: deliveryPreference,
          placedOrderCount: placedOrderCount,
          receivedOrderCount: receivedOrderCount,
        );

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
