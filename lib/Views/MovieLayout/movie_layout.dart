import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/ViewModels/Constants/constants.dart';
import 'package:gdsc_project/Views/Home%20Screen/home_screen.dart';

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
      BottomNavigationBarItem(icon: Icon(currentIndex==0? Icons.home:Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(icon: Icon(currentIndex==1? Icons.favorite: Icons.favorite_border), label: "Favourites"),
      BottomNavigationBarItem(icon: Icon(currentIndex==2? Icons.person: Icons.person_outline), label: "Profile"),
    ];

    return BlocProvider<MovieCubit>(
      create: (context){return MovieCubit()..getTrending()..getFavorites();},
      child: BlocConsumer<MovieCubit, MovieStates>(
        builder: (context, state){
          List<Widget> screens = [
            HomeScreen(),
            HomeScreen(),
            HomeScreen(),
          ];
          return Scaffold(
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: defaultColor,
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
        },
        listener: (context, state){
        },
      ),
    );
  }
}
