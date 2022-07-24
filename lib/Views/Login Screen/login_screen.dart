import 'package:flutter/material.dart';
import 'package:gdsc_project/Widgets/RegisterWidgets/password_widget.dart';
import '../../Widgets/RegisterWidgets/heading_widget.dart';
import '../../Widgets/RegisterWidgets/input_widget.dart';
import '../../Widgets/RegisterWidgets/signin_widget.dart';

class LoginScreen extends StatelessWidget{
   LoginScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formState,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                height: MediaQuery.of(context).size.height - 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeadingWidget(),
                    InputWidget("Email", emailController, "Email",
                        "Email is Required", Icons.email),
                    PasswordWidget(passwordController),
                    SignWidget(formState, emailController, passwordController)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
