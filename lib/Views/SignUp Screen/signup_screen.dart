import 'package:flutter/material.dart';
import 'package:gdsc_project/Widgets/RegisterWidgets/heading_widget.dart';
import 'package:gdsc_project/Widgets/RegisterWidgets/signup_widget.dart';
import '../../Widgets/RegisterWidgets/input_widget.dart';
import '../../Widgets/RegisterWidgets/password_widget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              height: MediaQuery.of(context).size.height - 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HeadingWidget(),
                  InputWidget("Name", nameController, "Name", "Name is Required",
                      Icons.person),
                  InputWidget("Email", emailController, "Email",
                      "Email is Required", Icons.email),
                  InputWidget("Phone", phoneController, "Phone",
                      "Phone is Required", Icons.phone),
                  PasswordWidget(passwordController),
                  SignUpWidget(nameController, emailController, phoneController,
                      passwordController, formState)
                ],
              ),
            ),
          ),
        ),
    ));
  }
}
