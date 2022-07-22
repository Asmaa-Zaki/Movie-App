import 'package:flutter/material.dart';
import 'package:gdsc_project/Widgets/RegisterWidgets/heading_widget.dart';
import 'package:gdsc_project/Widgets/RegisterWidgets/signup_widget.dart';
import '../../Widgets/RegisterWidgets/input_widget.dart';
import '../../Widgets/RegisterWidgets/password_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();
    var formState = GlobalKey<FormState>();

    return Scaffold(
        body: Form(
      key: formState,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            height: MediaQuery.of(context).size.height - 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HeadingWidget(),
                InputWidget("Email", emailController, "Email",
                    "Email is Required", Icons.email),
                InputWidget("Name", nameController, "Name", "Name is Required",
                    Icons.person),
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
