import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    try {
      emit(ProfileLoading());
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          emit(ProfileLoaded(
            userName: data['userName'] ?? '',
            email: data['email'] ?? '',
            phoneNumber: data['phoneNumber'] ?? '',
            gender: data['gender'] ?? '',
            profileImageUrl: data['profileImageUrl'] ?? '',
          ));
        } else {
          emit(ProfileError('User profile not found'));
        }
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      emit(ProfileError('Failed to fetch user profile: $e'));
    }
  }

  Future<void> updateProfile({
    required String userName,
    required String phoneNumber,
    required String gender,
    required String profileImageUrl,
  }) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .update({
          'userName': userName,
          'phoneNumber': phoneNumber,
          'gender': gender,
          'profileImageUrl': profileImageUrl,
        });
        fetchUserProfile();
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}
