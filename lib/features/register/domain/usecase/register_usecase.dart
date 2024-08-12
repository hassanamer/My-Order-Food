import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';

class RegisterUsecase {
  // final RegisterAccountRepository _registerAccountRepository;

  RegisterUsecase();

  Future<BaseResponse> call(RegisterAccountEntity registerAccount) async {
    // return await _registerAccountRepository.registerAccount(registerAccount);
    throw UnimplementedError();
  }
}
