import 'package:flutter/material.dart';
import '../../ViewModels/Constants/constants.dart';

class FavouriteFilmImage extends StatelessWidget {
  const FavouriteFilmImage(this.imageUrl, {Key? key}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
              image: NetworkImage(url+imageUrl),
              fit: BoxFit.fill
          )
      ),
    );
  }
}
