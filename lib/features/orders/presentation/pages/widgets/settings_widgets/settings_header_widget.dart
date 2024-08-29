import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/register/presentation/cubit/profile_cubit.dart';
import 'package:order/features/register/presentation/pages/user_profile_screen.dart';

class SettingsHeaderWidget extends StatefulWidget {
  const SettingsHeaderWidget({super.key});

  @override
  _SettingsHeaderWidgetState createState() => _SettingsHeaderWidgetState();
}

class _SettingsHeaderWidgetState extends State<SettingsHeaderWidget> {
  String userName = '';
  String email = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (BuildContext context, ProfileState state) {
        if (state is ProfileLoaded) {
          setState(() {
            userName = state.userName;
            email = state.email;
            profileImageUrl = state.profileImageUrl;
          });
        }
      },
      builder: (BuildContext context, ProfileState state) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const UserProfileScreen()));
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: <Color>[
                  Colors.white,
                  Colors.white70,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GradientCircleAvatar(
                  profileImageUrl: profileImageUrl,
                  width: 140.w,
                  height: 140.h,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font20BlueGradienteBoldForItemsList,
                      ),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font16BlueGradienteBoldForItemsList,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
