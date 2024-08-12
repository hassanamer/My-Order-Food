import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/register/user/pages/user_profile_screen.dart';
import 'package:order/features/register/user/profile_cubit.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 9, color: Color.fromRGBO(179, 192, 195, 0.08)),
              ],
              color: Color.fromRGBO(255, 255, 255, 1),
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
                        style: TextStyles.font18DarkBlueBold,
                      ),
                      Text(
                        email,
                        maxLines: 1,
                        style: TextStyles.font14DarkBlueBold,
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
