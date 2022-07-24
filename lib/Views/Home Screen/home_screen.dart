import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import '../../Widgets/HomeScreenWidgets/create_movie_heading.dart';
import '../../Widgets/HomeScreenWidgets/create_movie_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovieCubit.get(context).getAllMovie();

    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (BuildContext context, state) {
        var trendingList = MovieCubit.get(context).trendingData;
        var playingList = MovieCubit.get(context).nowPlayingData;
        var upcomingList = MovieCubit.get(context).upComingData;

        return ConditionalBuilder(
          fallback: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            ));
          },
          condition:
              MovieCubit.get(context).loaded || state is GetUpComingSuccess,
          builder: (BuildContext context) {
            return Scaffold(
                body: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CreateMovieHeading(context, "Trending", "Movies"),
                              const SizedBox(
                                height: 15,
                              ),
                              CreateMovieList(itemList: trendingList!.results),
                              const SizedBox(
                                height: 20,
                              ),
                              CreateMovieHeading(
                                  context, "Now Playing", "Movies"),
                              const SizedBox(
                                height: 10,
                              ),
                              CreateMovieList(itemList: playingList!.results),
                              const SizedBox(
                                height: 20,
                              ),
                              CreateMovieHeading(context, "Upcoming", "Movies"),
                              const SizedBox(
                                height: 10,
                              ),
                              CreateMovieList(itemList: upcomingList!.results),
                            ],
                          ),
                        ))));
          },
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
