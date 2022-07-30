import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/Views/Login%20Screen/login_screen.dart';
import 'package:gdsc_project/Widgets/ProfileScreenWidgets/create_profile_action.dart';
import 'package:gdsc_project/Widgets/SharedWidgtes/navigation.dart';

import '../../ViewModels/Block/cubit.dart';
import '../../ViewModels/Constants/constants.dart';
import '../../Widgets/ProfileScreenWidgets/profile_user_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovieCubit.get(context).getUserInfo();
    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (context, state) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ConditionalBuilder(
              condition: state is !GetUserLoading,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const ProfileUserInfo(),
                      const SizedBox(
                        height: 60,
                      ),
                      CreateProfileAction(
                        icon: Icons.favorite, color: Colors.red, text: "Favourites", onTap: () {
                        MovieCubit.get(context).changeCurrentIndex(1);
                      },),
                      const SizedBox(height: 40,),
                      CreateProfileAction(
                        icon: Icons.star, color: Colors.amber, text: "Rates", onTap: () {
                        MovieCubit.get(context).changeCurrentIndex(2);
                      },),
                      const SizedBox(
                        height: 40,
                      ),
                      BlocConsumer<MovieCubit, MovieStates>(
                        builder: (context, state) {
                          return CreateProfileAction(
                            icon: Icons.logout, color: Colors.white, text: "Log Out", onTap: () {
                            MovieCubit.get(context).logOut();
                          },);
                        },
                        listener: (context, state){
                          if(state is UserLogout)
                          {
                            navigateAndReplace(context,  LoginScreen());
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              fallback: (BuildContext context) {
                return Center(child:
                  CircularProgressIndicator(
                    color: defaultColor,
                  ));
              },
            ),
          ),
        );
      },
      listener: (context, state){},
    );
  }
}
