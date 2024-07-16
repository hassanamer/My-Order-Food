import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:order/core/database/firebase_db.dart';
import 'package:order/features/register/data/models/register_account_model.dart';
import 'package:order/features/register/domain/entities/register_entities.dart';

abstract class RemoteRegisterDatasource {
  Future<RegisterAccountEntity> remoteRegisterUser(String email, String password, RegisterAccountEntity registerAccountEntity);
  Future<RegisterAccountModel> getUserInfo();
}

class RemoteRegisterDatasourceImlp implements RemoteRegisterDatasource {
  late FirebaseDatabseProvider firebaseDB;

  String? idUser;
  RemoteRegisterDatasourceImlp(this.firebaseDB);

  @override
  Future<RegisterAccountEntity> remoteRegisterUser(String email, String password, RegisterAccountEntity registerAccountEntity) async {
    try {
      final userData = await firebaseDB.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firebaseDB.firebaseFirestore.collection("Users").doc(userData.user!.uid).set({
        "idUser": userData.user!.uid,
        "email": userData.user!.email,
        "gender": registerAccountEntity.gender,
        "name": registerAccountEntity.name,
        "phoneNumber": registerAccountEntity.phoneNumber,
        "userName": registerAccountEntity.username,
      });

      return RegisterAccountEntity(
        idUser: idUser,
        email: email,
        gender: registerAccountEntity.gender,
        name: registerAccountEntity.name,
        phoneNumber: registerAccountEntity.phoneNumber,
        username: registerAccountEntity.username,
        message: registerAccountEntity.message,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return RegisterAccountEntity(message: "Your email address appears to be malformed.");
        case "wrong-password":
          return RegisterAccountEntity(message: "Your password is wrong.");
        case "user-not-found":
          return RegisterAccountEntity(message: "User with this email doesn't exist.");
        case "user-disabled":
          return RegisterAccountEntity(message: "User with this email has been disabled.");
        case "too-many-requests":
          return RegisterAccountEntity(message: "Too many requests");
        case "operation-not-allowed":
          return RegisterAccountEntity(message: "Signing in with Email and Password is not enabled.");
        default:
          return RegisterAccountEntity(message: "An undefined Error happened.");
      }
    } catch (e) {
      return RegisterAccountEntity(message: e.toString());
    }
  }

  @override
  Future<RegisterAccountModel> getUserInfo() async {
    User? getCurrentUser = firebaseDB.auth.currentUser;
    if (getCurrentUser == null) {
      return RegisterAccountModel(message: 'No current user', replyCode: 404);
    }

    try {
      DocumentSnapshot userSnapshot = await firebaseDB.firebaseFirestore
          .collection("Users")
          .doc(getCurrentUser.uid)
          .get();

      if (userSnapshot.exists) {
        RegisterAccountModel registerAccountModel = RegisterAccountModel.fromMap(userSnapshot.data() as Map<String, dynamic>?);
        if (kDebugMode) {
          print("user data ${registerAccountModel.name}");
        }
        return registerAccountModel;
      } else {
        return RegisterAccountModel(message: 'User not found', replyCode: 404);
      }
    } catch (e) {
      return RegisterAccountModel(message: e.toString(), replyCode: 500);
    }
  }
}
