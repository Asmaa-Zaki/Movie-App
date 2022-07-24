import 'dart:ui';

import 'package:flutter/material.dart';

class CreateInput extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final Function()? onTap;
  final FocusNode? myFocusNode;
  final IconData? prefix;
  final IconData? suffix;
  final TextInputType? keyboard;
  final bool? password;
  final double borderRadius = 0;
  final Function()? changePassword;
  final Function()? onEditingComplete;
  final bool readOnly = false;

  const CreateInput(
      {Key? key,
      this.label,
      this.controller,
      this.validate,
      this.onTap,
      this.myFocusNode,
      this.prefix,
      this.suffix,
      this.keyboard,
      this.password,
      this.changePassword,
      this.onEditingComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboard,
      controller: controller,
      validator: validate,
      obscureText: password?? false,
      readOnly: readOnly,
      onEditingComplete: onEditingComplete,
      focusNode: myFocusNode,
      // cursorColor: defaultColor,
      decoration: InputDecoration(
        fillColor: Colors.grey[900],
        filled: true,
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color(0xff6b29d6))),
        isDense: true,
        // label: Text(label!),
        labelText: label,
        focusColor: Color(0xff6b29d6),
        prefixIcon: Icon(prefix /*,color: defaultColor,*/),
        suffixIcon: GestureDetector(
          child: Icon(suffix /*,color: defaultColor,*/),
          onTap: changePassword,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onTap: onTap,
    );
  }
}
