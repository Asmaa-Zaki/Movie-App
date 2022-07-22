import 'package:flutter/material.dart';
import '../input_field.dart';
import '../text_field.dart';

class PasswordWidget extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordWidget(this.passwordController, {Key? key}) : super(key: key);
  @override
  State<PasswordWidget> createState() => _PasswordPartState();
}

class _PasswordPartState extends State<PasswordWidget> {
  bool passwordVisible= true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: CreateText("Password")),
        const SizedBox(
          height: 10,
        ),
        CreateInput(
          password: passwordVisible,
          changePassword: (){
            setState(() {
              passwordVisible= !passwordVisible;
            });
          },
          controller: widget.passwordController,
          label: "Password",
          validate: (input) {
            if (input!.isEmpty) {
              return "Password Field is Required";
            }
            return null;
          },
          prefix: Icons.lock,
          suffix: !passwordVisible? Icons.visibility: Icons.visibility_off,
        ),
      ],
    );
  }
}
