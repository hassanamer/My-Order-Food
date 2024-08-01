import '../../domain/entities/account_entites.dart';

class User extends Account {
  User({
    required String userId,
    required String username,
    required String password,
    final String? name,
    final String? email,
    final String? phoneNumber,
    final String? gender,
  }) : super(
          userId: userId,
          username: username,
          password: password,
          email: email,
          gender: gender,
          name: name,
          phoneNumber: phoneNumber,
        );

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
