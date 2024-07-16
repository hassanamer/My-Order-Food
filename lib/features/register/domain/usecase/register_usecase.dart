import 'package:order/features/event/domain/entities/event_entities.dart';

import '../entities/register_entities.dart';

class RegisterUsecase {
  // final RegisterAccountRepository _registerAccountRepository;

  RegisterUsecase();

  Future<BaseResponse> call(RegisterAccountEntity registerAccount) async {
    // return await _registerAccountRepository.registerAccount(registerAccount);
    throw UnimplementedError();
  }
}
