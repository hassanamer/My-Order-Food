import '../../domain/entities/account_entites.dart';

class User extends Account {
  User({
    String? idUser,
    required String username,
    required String password,
    final String? name,
    final String? email,
    final String? phoneNumber,
    final String? gender,
  }) : super(
          idUser: idUser,
          username: username,
          password: password,
          email: email,
          gender: gender,
          name: name,
          phoneNumber: phoneNumber,
        );

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(map) {
    return User(
      idUser: map['idUser'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }
}
