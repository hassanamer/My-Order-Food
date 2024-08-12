import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/features/register/domain/reposisatory/register_reprisatory.dart';

class GetUserInfoUsecase {
  final RegisterAccountRepository _registerAccountRepository;

  GetUserInfoUsecase(this._registerAccountRepository);

  Future<RegisterAccountModel> call() async {
    return await _registerAccountRepository.getUserInfo();
  }
}
