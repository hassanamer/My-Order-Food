import 'package:order/features/login/domain/entities/account_entites.dart';

abstract class AccountRepository {
  // Future<LoginBaseResponse> login(String username, String password);
  Future<LoginBaseResponse> remoteLogin(String email, String password);
  Future<LoginBaseResponse> remoteLogout();
}
