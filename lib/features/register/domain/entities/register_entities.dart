import 'package:order/features/login/domain/entities/account_entites.dart';

class RegisterAccountEntity extends Account {
  RegisterAccountEntity(
      {super.userId,
      super.username,
      super.password,
      super.name,
      super.email,
      super.phoneNumber,
      super.gender,
      super.message,
      super.replyCode,
      super.profileImageUrl,
      super.fcmToken,
      super.hasCar,
      super.deliveryPreference,
      super.placedOrderCount = 0,
      super.receivedOrderCount = 0});
}
