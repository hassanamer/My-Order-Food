class Account {
  final String? idUser;
  final String? username;
  final String? password;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? message;
  final int? replyCode;
  Account({
    this.idUser,
    this.username,
    this.password,
    this.name,
    this.email,
    this.phoneNumber,
    this.gender,
    this.message,
    this.replyCode,
  });
}

class LoginBaseResponse {
  bool status;
  String message;

  LoginBaseResponse({required this.status, required this.message});
}
