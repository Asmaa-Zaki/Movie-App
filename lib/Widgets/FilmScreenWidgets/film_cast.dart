import 'package:flutter/material.dart';

import '../../ViewModels/Block/cubit.dart';
import '../../ViewModels/Constants/constants.dart';

class FilmCastWidget extends StatelessWidget {
  const FilmCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: MovieCubit.get(context).cast[index].profilePath != null
                    ? SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  image: DecorationImage(
                                      image: NetworkImage(url +
                                          MovieCubit.get(context)
                                              .cast[index]
                                              .profilePath!),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              MovieCubit.get(context).cast[index].name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    : null,
              ),
              itemCount: MovieCubit.get(context).cast.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 20,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
