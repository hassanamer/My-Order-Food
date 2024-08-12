import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order/features/register/domain/reposisatory/register_reprisatory.dart';
import 'package:order/injection_container.dart';

class CRUDService {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  late RegisterAccountRepository registerAccountRepository;

  Future<void> saveUserToken(String? fcmToken) async {
    try {
      registerAccountRepository = sl();
      registerAccountRepository.updateUserFcmToken(userId!, fcmToken!);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update(<String, String>{'fcmToken': fcmToken});
      print('Updated successfully');
    } catch (e) {
      print(e.toString());
    }
  }
}
