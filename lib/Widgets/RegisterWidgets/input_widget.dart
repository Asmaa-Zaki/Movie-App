import 'package:flutter/material.dart';
import '../SharedWidgtes/input_field.dart';
import '../SharedWidgtes/text_field.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController nameController;
  final String header;
  final String label;
  final IconData prefixIcon;
  final String errorMessage;
  const InputWidget(this.header, this.nameController, this.label, this.errorMessage, this.prefixIcon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateText(header),
        const SizedBox(
          height: 10,
        ),
        CreateInput(
            prefix: prefixIcon,
            label: label,
            controller: nameController,
            validate: (value) {
              if (value!.isEmpty) {
                return errorMessage;
              }
              return null;
            }),
      ],
    );
  }
}
