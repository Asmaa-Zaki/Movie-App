import 'package:flutter/material.dart';
import 'package:gdsc_project/Widgets/FilmScreenWidgets/film_rate.dart';

import '../../Models/MovieModel/movie_model.dart';
import '../../ViewModels/Constants/constants.dart';
import 'film_fav.dart';

class FilmRateFavWidget extends StatelessWidget {
  final MovieResult movie;
  const FilmRateFavWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image.network(
                  url +
                      movie.poster!,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0),
                            Colors.black,
                            Colors.black,
                            Colors.black
                          ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        movie.title!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      Text(movie.releaseDate!),
                      FilmRateWidget(movie: movie,)
                    ],
                  ),
                )
              ],
            ),
            FilmFavWidget(movie: movie,)
          ],
        ));
  }
}
