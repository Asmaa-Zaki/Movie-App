import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/Widgets/FavouriteScreenWidgets/favourite_details_widget.dart';
import '../../Widgets/FavouriteScreenWidgets/favourite_icon_widget.dart';
import '../../Widgets/FavouriteScreenWidgets/favourite_image_widget.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovieCubit.get(context).getFavouriteMovies();
    return BlocConsumer<MovieCubit, MovieStates>(
      builder: (context, state) {
      //  var MovieCubit.get(context).favMovies= MovieCubit.get(context).favMovies;
        return Scaffold(
          body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Card(
              color: Colors.grey.withOpacity(.1),
              child: Container(
              padding: const EdgeInsets.all(6.0),
              height: 150,
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  FavouriteFilmImage(MovieCubit.get(context).favMovies[index].poster!),
                  const SizedBox(width: 10,),
                  FavouriteFilmDetails(MovieCubit.get(context).favMovies[index].title!, MovieCubit.get(context).favMovies[index].releaseDate!, MovieCubit.get(context).favMovies[index].voteAverage!),
                  FavouriteFilmIcon(MovieCubit.get(context).favMovies[index])
                ],
              )),
            ),
        separatorBuilder: (context, index) => Container(
        height: 2,
        ),
        itemCount: MovieCubit.get(context).favMovies.length));
      },
      listener: (context, state){
      },
    );
  }
}
