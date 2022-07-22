import 'package:flutter/material.dart';
import 'package:gdsc_project/Widgets/RegisterWidgets/password_widget.dart';
import '../../Widgets/RegisterWidgets/heading_widget.dart';
import '../../Widgets/RegisterWidgets/input_widget.dart';
import '../../Widgets/RegisterWidgets/signin_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formState = GlobalKey<FormState>();
  IconData suffixIcon = Icons.remove_red_eye;
  late String message;

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
