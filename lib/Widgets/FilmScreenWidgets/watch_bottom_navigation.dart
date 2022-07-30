import 'package:flutter/material.dart';

class WatchNowWidget extends StatelessWidget {
  const WatchNowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          // MovieCubit.get(context).openTeaserOnYoutube();
        },
        child: const Text(
          "Watch Now",
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size.fromHeight(40)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.red),
          )),
          backgroundColor: MaterialStateProperty.all(
              Colors.pinkAccent.withOpacity(.8)),
        ),
      ),
    );
  }
}
