import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void fetchUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists) {
        emit(ProfileLoaded(
          userName: userSnapshot['userName'] ?? '',
          email: userSnapshot['email'] ?? '',
          phoneNumber: userSnapshot['phoneNumber'] ?? '',
          gender: userSnapshot['gender'] ?? '',
          profileImageUrl: userSnapshot['profileImageUrl'] ?? '',
        ));
      }
    }
  }

  void updateProfile({
    required String userName,
    required String phoneNumber,
    required String gender,
    String? profileImageUrl,
  }) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).update({
        'userName': userName,
        'phoneNumber': phoneNumber,
        'gender': gender,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      });

      fetchUserProfile(); // Re-fetch user profile to update state
    }
  }
}
