import 'package:order/core/database/database.dart';
import 'package:order/features/event/domain/entities/order_entities.dart';
import 'package:order/features/register/data/models/register_account_model.dart';

abstract class RegisterDatasource {
  Future<BaseResponse> insertUser(RegisterAccountModel registerAccount);

  Future<bool> confirmeSelectUser(RegisterAccountModel registerAccount);
}

class RegisterDatasourceImpl implements RegisterDatasource {
  late DatabaseProvider db;

  RegisterDatasourceImpl(this.db);

  @override
  Future<bool> confirmeSelectUser(RegisterAccountModel registerAccount) async {
    List<Map<String, dynamic>> records = await db.database.rawQuery(
        'select username FROM Users WHERE username=\'${registerAccount.username}\'');
    return records.isNotEmpty;
  }

  @override
  Future<BaseResponse> insertUser(RegisterAccountModel registerAccount) async {
    if (await confirmeSelectUser(registerAccount)) {
      return BaseResponse(status: false, message: 'User already exists');
    } else {
      int value = await db.database.insert('Users', registerAccount.toMap());
      if (value != 0) {
        return BaseResponse(status: true, message: 'User created successfully');
      } else {
        return BaseResponse(status: false, message: 'Something went wrong');
      }
    }
  }
}
