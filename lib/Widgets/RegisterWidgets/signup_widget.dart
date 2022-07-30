import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/Views/MovieLayout/movie_layout.dart';

import '../../ViewModels/Constants/constants.dart';
import '../../ViewModels/Local/CacheHelper.dart';
import '../../Views/Login Screen/login_screen.dart';
import '../SharedWidgtes/navigation.dart';

class SignUpWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formState;

  const SignUpWidget(this.nameController, this.emailController,
      this.phoneController, this.passwordController, this.formState,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (context, state) {
        return Column(children: [
          ConditionalBuilder(
              condition: state is! SignUpLoading,
              builder: (context) => MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 2,
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        MovieCubit.get(context).signUp(
                            name: nameController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                            password: passwordController.text);
                      }
                    },
                    child: const Text(
                      "SignUp",
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
              fallback: (context) => CircularProgressIndicator(color: defaultColor,)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                  onPressed: () {
                    navigateAndReplace(context,  LoginScreen());
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17),
                  ))
            ],
          ),
        ]);
      },
      listener: (context, state) {
        if (state is SignUpSuccess) {
          CacheHelper.setData(key: "token", value: token);
          navigateAndReplace(context, const MovieLayout());
        }
        if (state is SignUpError)
          {
            Fluttertoast.showToast(
                msg: "Invalid data try again");
          }
      },
    );
  }
}
