import 'package:order/features/login/domain/entities/account_entites.dart';

class LoginUsecase {
  LoginUsecase();

  Future<LoginBaseResponse> call(String username, String password) async {
    // return await _accountRepository.login(username, password);
    throw UnimplementedError();
  }
}
