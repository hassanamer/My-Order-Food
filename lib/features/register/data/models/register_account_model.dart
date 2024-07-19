import '../../domain/entities/register_entities.dart';

class RegisterAccountModel extends RegisterAccountEntity {
  RegisterAccountModel({
    String? userId,
    String? username,
    String? name,
    String? email,
    String? phoneNumber,
    String? gender,
    String? message,
    int? replyCode,
  }) : super(
          userId: userId,
          username: username,
          email: email,
          gender: gender,
          name: name,
          phoneNumber: phoneNumber,
          message: message,
          replyCode: replyCode,
        );

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': username,
      'name': name,
      'email': email,
      'gender': gender,
      'phoneNumber': phoneNumber,
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
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
