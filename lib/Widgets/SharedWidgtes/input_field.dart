import 'package:flutter/material.dart';
import 'package:gdsc_project/ViewModels/Constants/constants.dart';

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
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboard,
      controller: controller,
      validator: validate,
      obscureText: password?? false,
      readOnly: readOnly,
      onEditingComplete: onEditingComplete,
      focusNode: myFocusNode,
      decoration: InputDecoration(
        fillColor: Colors.grey[900],
        filled: true,
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: defaultColor)),
        isDense: true,
        labelText: label,
        focusColor: defaultColor,
        prefixIcon: Icon(prefix /*,color: defaultColor,*/),
        suffixIcon: GestureDetector(
          child: Icon(suffix /*,color: defaultColor,*/),
          onTap: changePassword,
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onTap: onTap,
    );
  }
}
