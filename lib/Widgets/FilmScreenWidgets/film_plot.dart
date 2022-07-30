import 'package:flutter/material.dart';

import '../../Models/MovieModel/movie_model.dart';

class FilmPlotWidget extends StatelessWidget {
  final MovieResult movie;
  const FilmPlotWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Plot",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            movie.overview!,
            style: const TextStyle(height: 1.4),
          )
        ],
      ),
    );
  }
}
