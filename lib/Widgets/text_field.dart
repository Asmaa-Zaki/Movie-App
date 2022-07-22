import 'package:flutter/material.dart';

class CreateText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const CreateText(this.text,{Key? key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline6,);
  }
}
