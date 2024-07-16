import 'package:order/features/login/domain/entities/account_entites.dart';
import 'package:order/features/login/domain/repositories/account_repository.dart';

class RemoteLoginUsecase {
  final AccountRepository accountRepository;
  RemoteLoginUsecase(this.accountRepository);

  Future<LoginBaseResponse> call(String email, String password) async {
    return await accountRepository.remoteLogin(email, password);
  }
}
