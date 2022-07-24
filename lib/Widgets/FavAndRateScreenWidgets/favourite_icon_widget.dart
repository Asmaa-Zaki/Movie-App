import 'package:flutter/material.dart';
import 'package:gdsc_project/Models/movie_model.dart';
import '../../ViewModels/Block/cubit.dart';

class FavouriteFilmIcon extends StatelessWidget {
  const FavouriteFilmIcon(this.movie, {Key? key}) : super(key: key);
  final MovieResult movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomEnd,
      child: IconButton(
        icon: Icon(
          MovieCubit.get(context).favouritesMovies[movie.id!]!
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red,
          size: 19,
        ),
        onPressed: () {
          MovieCubit.get(context).changeFav(movie.id!);
        },
      ),
    );
  }
}
