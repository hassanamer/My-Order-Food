part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => <Object>[];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String profileImageUrl;

  const ProfileLoaded({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.profileImageUrl,
  });

  @override
  List<Object> get props =>
      <Object>[userName, email, phoneNumber, gender, profileImageUrl];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => <Object>[message];
}
