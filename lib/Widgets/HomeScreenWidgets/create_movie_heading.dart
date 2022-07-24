import 'package:flutter/material.dart';
import 'package:gdsc_project/Widgets/HomeScreenWidgets/create_text_widget.dart';

class CreateMovieHeading extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String type;

  const CreateMovieHeading(this.context, this.title, this.type, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CreateMovieText(title, context, true),
        const SizedBox(
          width: 15,
        ),
        CreateMovieText(type, context, false),
        const Spacer(),
        const SizedBox(
            child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ))
      ],
    );
  }
}
