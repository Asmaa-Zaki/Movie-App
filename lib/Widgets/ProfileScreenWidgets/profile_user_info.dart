import 'package:flutter/material.dart';
import 'package:gdsc_project/Models/UserModel/UserModel.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';

class ProfileUserInfo extends StatelessWidget {
  const ProfileUserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user=  MovieCubit.get(context).user;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60.0),
          child: Image.asset(
            "assets/images/profile.jpg",
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8,),
        Text(
          user!.name!,
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 3,),
        Text(
          user.email!,
          style:  TextStyle(color: Colors.grey.withOpacity(.7)),
        ),
      ],
    );
  }
}
