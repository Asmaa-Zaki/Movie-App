import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/ViewModels/Block/cubit.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/Views/Login%20Screen/login_screen.dart';
import 'package:gdsc_project/Views/MovieLayout/movie_layout.dart';
import 'ViewModels/Block/BlocObserver.dart';
import 'ViewModels/Constants/constants.dart';
import 'ViewModels/Local/CacheHelper.dart';
import 'ViewModels/Network/DioHelper.dart';
import 'Views/SignUp Screen/signup_screen.dart';


void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      DioHelper.init();
      await CacheHelper.init();
      token = CacheHelper.getData(key: "token");
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget screen;
    if(token != null)
    {
      screen= const MovieLayout();
    }
    else
    {
      screen= const LoginScreen();
    }

    return BlocProvider<MovieCubit>(
      create: (BuildContext context) => MovieCubit(),
      child: BlocConsumer<MovieCubit, MovieStates>(
        builder: (BuildContext context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(
              primaryColor: const Color(0xff6b29d6),
              scaffoldBackgroundColor: Colors.black,
              inputDecorationTheme: const InputDecorationTheme(
                iconColor: Colors.white,
                enabledBorder:OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white10
                  )
                ),
                labelStyle: TextStyle(
                  color: Color(0xff6b29d6)
                )
              ),
           //   focusColor: Color(0xff6b29d6),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
                bodyText2: TextStyle(color: Colors.white,),
                headline6: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            themeMode: ThemeMode.dark,
            home: screen,
          );
        },
        listener: (BuildContext context, Object? state) {},
      ),
    );
  }
}
