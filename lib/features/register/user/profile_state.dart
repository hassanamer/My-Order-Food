part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String profileImageUrl;

  ProfileLoaded({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.profileImageUrl,
  });
}
