import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/Widgets/FilmScreenWidgets/film_cast.dart';

import '../../Models/MovieModel/movie_model.dart';
import '../../Widgets/FilmScreenWidgets/film_plot.dart';
import '../../Widgets/FilmScreenWidgets/film_rate_fav.dart';
import '../../Widgets/FilmScreenWidgets/watch_bottom_navigation.dart';

class FilmScreen extends StatelessWidget {
  final MovieResult movie;
  const FilmScreen(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return BlocConsumer<MovieCubit, MovieStates>(
        builder: (context, state) => ConditionalBuilder(
          condition: MovieCubit.get(context).castLoaded,
          builder:(context)=> Scaffold(
                extendBodyBehindAppBar: true,
                body: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FilmRateFavWidget(movie: movie),
                        const SizedBox(
                          height: 20,
                        ),
                        FilmPlotWidget(movie: movie,),
                        const FilmCastWidget(),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: const WatchNowWidget()
              ),
          fallback: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber,),
            );
          },
        ),
        listener: (context, state) {});
  }
}
