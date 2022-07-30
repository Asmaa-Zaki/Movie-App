import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Models/MovieModel/movie_model.dart';
import '../../ViewModels/Block/cubit.dart';

class FilmRateWidget extends StatelessWidget {
  final MovieResult movie;
  const FilmRateWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: 25,
      unratedColor: Colors.grey,
      initialRating: MovieCubit.get(context).rates[movie.id]! / 2,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        double rate = rating;
        MovieCubit.get(context).rateMovie(rate, movie.id!);
      },
    );
  }
}
