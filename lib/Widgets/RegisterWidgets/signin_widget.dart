import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/ViewModels/Constants/constants.dart';
import 'package:gdsc_project/Views/MovieLayout/movie_layout.dart';
import '../../ViewModels/Local/CacheHelper.dart';
import '../../Views/SignUp Screen/signup_screen.dart';
import '../SharedWidgtes/navigation.dart';

class SignWidget extends StatelessWidget {
  final GlobalKey<FormState> formState;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SignWidget(
      this.formState, this.emailController, this.passwordController,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (context, state) {
        return Column(
          children: [
            ConditionalBuilder(
                condition: state is! SignInLoading,
                builder: (context) {
                  return MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 2,
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        MovieCubit.get(context).signIn(
                            email: emailController.text,
                            password: passwordController.text);
                      }
                    },
                    child: const Text(
                      "Login",
                    ),
                    color: Theme.of(context).primaryColor,
                  );
                },
                fallback: (context) {
                  return CircularProgressIndicator(color: defaultColor,);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextButton(
                    onPressed: () {
                      navigateAndReplace(context, SignUpScreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            )
          ],
        );
      },
      listener: (context, state) {
        if (state is SignInSuccess) {
          navigateAndReplace(context, const MovieLayout());
          CacheHelper.setData(key: "token", value: token);
        }
      },
    );
  }
}
