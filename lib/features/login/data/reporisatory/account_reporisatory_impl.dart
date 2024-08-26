import 'package:order/features/login/data/datasources/remote_login_user.dart';
import 'package:order/features/login/domain/entities/account_entity.dart';
import 'package:order/features/login/domain/repositories/account_repository.dart';

class AccountRepositoryImlp implements AccountRepository {
  late RemoteLoginDatasource remoteLoginDatasource;

  AccountRepositoryImlp(this.remoteLoginDatasource);

  @override
  Future<LoginBaseResponse> remoteLogin(String email, String password) async {
    return await remoteLoginDatasource.remoteLoginUser(email, password);
  }

  @override
  Future<LoginBaseResponse> remoteLogout() async {
    return await remoteLoginDatasource.remoteLogoutUser();
  }
}
