import 'package:flutter/material.dart';

import '../../Models/MovieModel/movie_model.dart';
import '../../ViewModels/Block/cubit.dart';

class FilmFavWidget extends StatelessWidget {
  final MovieResult movie;
  const FilmFavWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 50, horizontal: 10),
      child: CircleAvatar(
        radius: 17,
        backgroundColor: Colors.black.withOpacity(.6),
        child: IconButton(
          onPressed: () {
            MovieCubit.get(context)
                .changeFav(movie.id!);
          },
          icon: Icon(
            MovieCubit.get(context).favouritesMovies[
            movie.id!]!
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
            size: 19,
          ),
        ),
      ),
    );
  }
}
