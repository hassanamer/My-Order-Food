import 'package:order/features/login/domain/entities/account_entites.dart';
import 'package:order/features/login/domain/repositories/account_repository.dart';

class RemoteLogoutUsecase {
  final AccountRepository accountRepository;
  RemoteLogoutUsecase(this.accountRepository);

  Future<LoginBaseResponse> call() async {
    return await accountRepository.remoteLogout();
  }
}
