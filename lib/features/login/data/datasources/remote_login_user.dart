import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/core/database/firebase_db.dart';
import 'package:order/features/login/domain/entities/account_entity.dart';

abstract class RemoteLoginDatasource {
  Future<LoginBaseResponse> remoteLoginUser(String email, String password);

  Future<LoginBaseResponse> remoteLogoutUser();
}

class RemoteLoginDatasourceImpl implements RemoteLoginDatasource {
  late FirebaseDatabseProvider firebaseDB;

  RemoteLoginDatasourceImpl(this.firebaseDB);

  @override
  Future<LoginBaseResponse> remoteLoginUser(
      String email, String password) async {
    try {
      await firebaseDB.auth
          .signInWithEmailAndPassword(email: email, password: password);
      return LoginBaseResponse(status: true, message: 'Successfully Logged In');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return LoginBaseResponse(status: false, message: 'User Not Found');
      } else if (e.code == 'wrong-password') {
        return LoginBaseResponse(status: false, message: 'Wrong Password');
      } else if (e.code == 'invalid-email') {
        return LoginBaseResponse(status: false, message: 'Invalid E-mail');
      }
    } catch (e) {
      return LoginBaseResponse(status: false, message: e.toString());
    }
    return LoginBaseResponse(status: false, message: 'Server Error');
  }

  @override
  Future<LoginBaseResponse> remoteLogoutUser() async {
    try {
      await firebaseDB.auth.signOut();
      return LoginBaseResponse(status: true, message: 'Logout Successfully');
    } catch (e) {
      return LoginBaseResponse(status: false, message: e.toString());
    }
  }
}
