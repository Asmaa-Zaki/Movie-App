import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/Views/Favourite%20Screen/favourite_screen.dart';
import 'package:gdsc_project/Views/Home%20Screen/home_screen.dart';
import 'package:gdsc_project/Views/Rates%20Screen/rate_screen.dart';

class MovieLayout extends StatefulWidget {
  const MovieLayout({Key? key}) : super(key: key);

  @override
  State<MovieLayout> createState() => _MovieLayoutState();
}

class _MovieLayoutState extends State<MovieLayout> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
          label: "Home"),
      BottomNavigationBarItem(
          icon:
              Icon(currentIndex == 1 ? Icons.favorite : Icons.favorite_border),
          label: "Favourites"),
      BottomNavigationBarItem(
          icon: Icon(currentIndex == 2 ? Icons.star : Icons.star_border),
          label: "Rates"),
      BottomNavigationBarItem(
          icon: Icon(currentIndex == 3 ? Icons.person : Icons.person_outline),
          label: "Profile"),
    ];
    List<Widget> screens = [
      HomeScreen(),
      FavouriteScreen(),
      RatesScreen(),
      HomeScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        items: items,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
