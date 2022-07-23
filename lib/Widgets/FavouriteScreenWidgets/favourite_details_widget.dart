import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavouriteFilmDetails extends StatelessWidget {
  final String title;
  final String date;
  final dynamic rate;
  const FavouriteFilmDetails(this.title, this.date, this.rate, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            date,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 5,
          ),
          RatingBar.builder(
            itemSize: 20,
            unratedColor: Colors.grey,
            initialRating: rate / 2,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            ignoreGestures: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
        ],
      ),
    ));
  }
}
