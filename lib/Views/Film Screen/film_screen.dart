import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import '../../Models/trending_model.dart';

class FilmScreen extends StatelessWidget {
  final MovieResult movie;
  const FilmScreen(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return BlocConsumer<MovieCubit, MovieStates>(
        builder: (context, state) => Scaffold(
              extendBodyBehindAppBar: true,
              body: ConditionalBuilder(
                condition: MovieCubit.get(context).castLoaded || state is !GetCastLoading,
                builder: (BuildContext context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 350,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      Image.network(
                                        "https://image.tmdb.org/t/p/w500" +
                                            movie.poster!,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      Container(
                                        height: 65,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              movie.title!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                            Text(movie.releaseDate!),
                                            Text("Rate Here"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50, horizontal: 10),
                                    child: CircleAvatar(
                                      radius: 17,
                                      backgroundColor:
                                          Colors.black.withOpacity(.6),
                                      child: IconButton(
                                        onPressed: () {
                                          MovieCubit.get(context)
                                              .changeFav(movie.id!);
                                        },
                                        icon: Icon(
                                          MovieCubit.get(context).favouritesMovies[movie.id!]??true?
                                          Icons.favorite: Icons.favorite_border,
                                          color: Colors.red,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Cast",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => SizedBox(
                                      height: 100,
                                      child: MovieCubit.get(context)
                                                  .cast[index]
                                                  .profilePath !=
                                              null
                                          ? SizedBox(
                                              width: 70,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    15)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                "https://image.tmdb.org/t/p/w500" +
                                                                    MovieCubit.get(
                                                                            context)
                                                                        .cast[
                                                                            index]
                                                                        .profilePath!),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    MovieCubit.get(context)
                                                        .cast[index]
                                                        .name!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            )
                                          : null,
                                    ),
                                    itemCount:
                                        MovieCubit.get(context).cast.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(
                                        width: 20,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                fallback: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Watch Now",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.fromHeight(40)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.red),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.pinkAccent.withOpacity(.8)),
                  ),
                ),
              ),
            ),
        listener: (context, state) {});
  }
}
