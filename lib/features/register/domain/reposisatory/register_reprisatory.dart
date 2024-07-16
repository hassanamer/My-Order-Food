import 'package:order/features/register/data/models/register_account_model.dart';

import '../entities/register_entities.dart';

abstract class RegisterAccountRepository {
  Future<RegisterAccountEntity> remoteRegisterUser(String email,
      String password, RegisterAccountEntity registerAccountEntity);

  Future<RegisterAccountModel> getUserInfo();
}
