import 'package:order/features/register/data/datasource/remote_register_user_datasource.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';

import '../../domain/reposisatory/register_reprisatory.dart';

class RegisterReporisatoryImpl implements RegisterAccountRepository {
  // late RegisterDatasource dataSource;
  late RemoteRegisterDatasource remoteRegisterDatasourceImlp;

  RegisterReporisatoryImpl(this.remoteRegisterDatasourceImlp);
  // @override
  // Future<BaseResponse> registerAccount(
  //     RegisterAccountEntity registerAccount) async {
  //   return await dataSource
  //       .insertUser(RegisterAccountModel.fromEntity(registerAccount));
  // }

  @override
  Future<RegisterAccountEntity> remoteRegisterUser(String email,
      String password, RegisterAccountEntity registerAccountEntity) async {
    return await remoteRegisterDatasourceImlp.remoteRegisterUser(
        email, password, registerAccountEntity);
  }

  @override
  Future<RegisterAccountModel> getUserInfo() async {
    return await remoteRegisterDatasourceImlp.getUserInfo();
  }
}
