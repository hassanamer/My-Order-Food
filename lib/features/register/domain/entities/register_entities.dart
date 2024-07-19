import 'package:order/features/login/domain/entities/account_entites.dart';

class RegisterAccountEntity extends Account {
  RegisterAccountEntity({
    String? userId,
    String? username,
    String? password,
    String? name,
    String? email,
    String? phoneNumber,
    String? gender,
    String? message,
    int? replyCode,
  }) : super(
          message: message,
          replyCode: replyCode,
          userId: userId,
          username: username,
          password: password,
          email: email,
          gender: gender,
          name: name,
          phoneNumber: phoneNumber,
        );
}
