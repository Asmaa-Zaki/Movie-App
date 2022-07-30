import 'package:flutter/material.dart';

import '../../Models/MovieModel/movie_model.dart';
import '../../ViewModels/Block/cubit.dart';
import '../../ViewModels/Constants/constants.dart';
import '../../Views/Film Screen/film_screen.dart';
import 'create_text_widget.dart';

class CreateMovieList extends StatelessWidget {
  final List<MovieResult> itemList;
  const CreateMovieList({Key? key, required this.itemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              MovieCubit.get(context).getCast(itemList[index].id!);
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
                        image: NetworkImage(url + itemList[index].poster!)),
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
                          child: CreateMovieText(
                              itemList[index].title!, context, false)),
                      const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      )
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
}
