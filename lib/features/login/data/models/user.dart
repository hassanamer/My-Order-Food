// ignore_for_file: always_specify_types

import 'package:order/features/login/domain/entities/account_entites.dart';

class User extends Account {
  User({
    required String super.userId,
    required String super.username,
    required String super.password,
    super.name,
    super.email,
    super.phoneNumber,
    super.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(map) {
    return User(
      userId: map['userId'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }
}
