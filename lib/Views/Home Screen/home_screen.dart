import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import '../Film Screen/film_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trendingList = MovieCubit.get(context).trendingData;
    var playingList = MovieCubit.get(context).nowPlayingData;
    var upcomingList = MovieCubit.get(context).upComingData;

    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (BuildContext context, state) {
        return ConditionalBuilder(
          fallback: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
          condition: MovieCubit.get(context).loaded|| state is GetUpComingSuccess,
          builder: (BuildContext context) {
            return Scaffold(
                body: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              createMovieHeading(context, "Trending", "Movies"),
                              const SizedBox(
                                height: 15,
                              ),
                              createMovieList(trendingList?.results),
                              const SizedBox(
                                height: 20,
                              ),
                              createMovieHeading(
                                  context, "Now Playing", "Movies"),
                              const SizedBox(
                                height: 10,
                              ),
                              createMovieList(playingList?.results),
                              const SizedBox(
                                height: 20,
                              ),
                              createMovieHeading(context, "Upcoming", "Movies"),
                              const SizedBox(
                                height: 10,
                              ),
                              createMovieList(upcomingList?.results),
                            ],
                          ),
                        ))));
          },
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }

  Row createMovieHeading(BuildContext context, String title, String type) {
    return Row(
      children: [
        createText(title, context, true),
        const SizedBox(
          width: 15,
        ),
        createText(type, context, false),
        const Spacer(),
        SizedBox(child: createArrowIcon())
      ],
    );
  }

  SizedBox createMovieList(var itemList) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemCount: itemList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FilmScreen(itemList[index])));
              MovieCubit.get(context).getCast(itemList[index].id);
            },
            child: Column(
              children: [
                Container(
                  width: 95,
                  height: 155,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("https://image.tmdb.org/t/p/w500" +
                            itemList[index].poster)),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 30,
                  width: 95,
                  child: Row(
                    children: [
                      Expanded(
                          child: createText(
                              itemList[index].title, context, false)),
                      createIcon()
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 15,
          );
        },
      ),
    );
  }

  Icon createArrowIcon() => const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      );

  Icon createIcon() => const Icon(
        Icons.more_vert,
        color: Colors.white,
      );

  Text createText(String text, BuildContext context, bool black) => Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: black == true
            ? Theme.of(context).textTheme.bodyText1
            : Theme.of(context).textTheme.bodyText2,
      );
}
