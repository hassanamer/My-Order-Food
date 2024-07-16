import 'dart:async';

import 'package:order/core/database/database.dart';
import 'package:order/features/login/data/models/user.dart';

abstract class LocalDatabaseDataSource {
  Future<User?> selectUser(User user);
}

class DatabaseDataSourceImpl implements LocalDatabaseDataSource {
  late DatabaseProvider db;
  DatabaseDataSourceImpl(this.db);

  @override
  Future<User?> selectUser(User user) async {
    List<Map<String, dynamic>> records = await db.database.rawQuery(
        'select id, username, password FROM Users WHERE username=\'${user.username}\'');
    if (records.isNotEmpty) {
      return User.fromMap(records.first);
    } else {
      return null;
    }
  }
}
