import 'package:order/features/login/domain/entities/account_entity.dart';

abstract class AccountRepository {
  Future<LoginBaseResponse> remoteLogin(String email, String password);

  Future<LoginBaseResponse> remoteLogout();
}
