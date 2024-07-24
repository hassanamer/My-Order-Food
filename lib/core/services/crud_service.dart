import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/register/domain/reposisatory/register_reprisatory.dart';
import '../../injection_container.dart';

class CRUDService {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  late RegisterAccountRepository registerAccountRepository;

  Future saveUserToken(String? fcmToken) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {"userId": user!.uid, "fcmToken": fcmToken};

    try {
      registerAccountRepository = sl();
      registerAccountRepository.updateUserFcmToken(userId!, fcmToken!);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'fcmToken': fcmToken});
      print("updated success");
    } catch (e) {
      print(e.toString());
    }
  }
}
