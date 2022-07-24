import 'package:flutter/material.dart';

class CreateMovieText extends StatelessWidget {
  final String text;
  final BuildContext ctx;
  final bool black;
  const CreateMovieText(this.text, this.ctx, this.black, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: black == true
          ? Theme.of(ctx).textTheme.bodyText1
          : Theme.of(ctx).textTheme.bodyText2,
    );
  }
}
