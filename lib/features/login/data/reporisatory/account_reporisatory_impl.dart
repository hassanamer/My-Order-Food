import 'package:order/features/login/data/datasources/remote_login_user.dart';
import 'package:order/features/login/domain/entities/account_entites.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImlp implements AccountRepository {
  //late LocalDatabaseDataSource databaseDatasourceImpl;
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

  // @override
  // Future<LoginBaseResponse> login(String username, String password) async {
  //   User loggedUser = User(username: username, password: password);
  //   User? confirmedUser = await databaseDatasourceImpl.selectUser(loggedUser);
  //   if (confirmedUser != null) {
  //     if (loggedUser.password == confirmedUser.password) {
  //       return LoginBaseResponse(status: true, message: 'Successfull Password');
  //     } else {
  //       return LoginBaseResponse(status: false, message: 'Wrong Password');
  //     }
  //   } else {
  //     return LoginBaseResponse(status: false, message: 'Wrong username');
  //   }
  // }
}
