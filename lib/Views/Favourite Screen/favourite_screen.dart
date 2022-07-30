import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';

import '../../Widgets/FavAndRateScreenWidgets/favourite_details_widget.dart';
import '../../Widgets/FavAndRateScreenWidgets/favourite_icon_widget.dart';
import '../../Widgets/FavAndRateScreenWidgets/favourite_image_widget.dart';


class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovieCubit.get(context).getFavouriteMovies();
    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (context, state) {
        var favList = MovieCubit.get(context).favMovies;
        return Scaffold(
            body: SafeArea(
          child: ConditionalBuilder(
            fallback: (BuildContext context) {
              return const Center(child: Text("Your Favourites Page is Empty"));
            },
            condition: favList.isNotEmpty,
            builder: (BuildContext context) {
              return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Card(
                        color: Colors.grey.withOpacity(.1),
                        child: Container(
                            padding: const EdgeInsets.all(6.0),
                            height: 150,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                FavAndRateFilmImage(favList[index].poster!),
                                const SizedBox(
                                  width: 10,
                                ),
                                FavAndRateFilmDetails(
                                    favList[index].title!,
                                    MovieCubit.get(context)
                                        .favMovies[index]
                                        .releaseDate!,
                                    MovieCubit.get(context)
                                        .favMovies[index]
                                        .voteAverage!),
                                FavouriteFilmIcon(favList[index])
                              ],
                            )),
                      ),
                  separatorBuilder: (context, index) => Container(
                        height: 2,
                      ),
                  itemCount: favList.length);
            },
          ),
        ));
      },
      listener: (context, state) {},
    );
  }
}
