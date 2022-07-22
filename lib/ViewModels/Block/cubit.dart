import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/Models/cast_model.dart';
import 'package:gdsc_project/Models/favourite_model.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/ViewModels/Network/DioHelper.dart';
import '../../Models/UserModel/UserModel.dart';
import '../../Models/trending_model.dart';
import '../Constants/constants.dart';

class MovieCubit extends Cubit<MovieStates> {
  MovieCubit() : super(MovieInitState());

  static MovieCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  MovieModel? trendingData;
  String apiKey= "124effc8a380dc90cebeb87480f9f52e";

  getTrending() {
    emit(GetTrendingLoading());
    DioHelper.getData(url: "trending/movie/day", queries: {
      "api_key": apiKey
    }).then((value) {
      trendingData = MovieModel.fromJson(value.data);
      emit(GetTrendingSuccess());
      getNowPlaying();
    }).catchError((err) {
      emit(GetTrendingError());
    });
  }

  MovieModel? nowPlayingData;

  getNowPlaying() {
    emit(GetNowPlayingLoading());
    DioHelper.getData(url: "movie/now_playing", queries: {
      "api_key": apiKey
    }).then((value) {
      nowPlayingData = MovieModel.fromJson(value.data);
      emit(GetNowPlayingSuccess());
      getUpComing();
    }).catchError((err) {
      emit(GetNowPlayingError());
    });
  }

  bool loaded = false;
  MovieModel? upComingData;

  getUpComing() {
    emit(GetUpComingLoading());
    DioHelper.getData(url: "movie/upcoming", queries: {
      "api_key": apiKey
    }).then((value) {
      upComingData = MovieModel.fromJson(value.data);
      setFavourites();
      Timer(const Duration(seconds: 2), (() {
        loaded = true;
        emit(GetUpComingSuccess());
      }
      ));
    }).catchError((err) {
      emit(GetUpComingError());
    });
  }

  List<CastModel> cast = [];
  bool castLoaded= false;
  getCast(int id) {
    cast = [];
    emit(GetCastLoading());
    DioHelper.getData(url: "movie/$id/credits", queries: {
      "api_key": apiKey
    }).then((value) {
      value.data["cast"].forEach((element) {
        cast.add(CastModel.fromJson(element));
      });
        castLoaded= true;
        emit(GetCastSuccess());
    }).catchError((err) {
      emit(GetCastError());
    });
  }

//Firebase
//Favourites
  List<FavouriteMovies> favourites = [];
  Map<int, bool> favouritesMovies = {};
  setFavourites()
  {
    trendingData?.results.forEach((element){
        favouritesMovies.addAll({element.id!: element.inFav});
    });
    nowPlayingData?.results.forEach((element){
      favouritesMovies.addAll({element.id!: element.inFav});
    });
    trendingData?.results.forEach((element){
      favouritesMovies.addAll({element.id!: element.inFav});
    });
    getAllMovie();
  }

  getAllMovie()
  {
    trendingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if(element.id == fElement.movieId)
          {
            element.inFav= true;
            favouritesMovies.addAll({element.id! : element.inFav});
            emit(ChangeFavUIScreen());
          }
      });
    });

    upComingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if(element.id == fElement.movieId)
        {
          element.inFav= true;
          favouritesMovies.addAll({element.id! : element.inFav});
          emit(ChangeFavUIScreen());
        }
      });
    });

    nowPlayingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if(element.id == fElement.movieId)
        {
          element.inFav= true;
          favouritesMovies.addAll({element.id! : element.inFav});
          emit(ChangeFavUIScreen());
        }
      });
    });
  }

  getFavorites() {
    favourites = [];
    FirebaseFirestore.instance.collection("Favourites").get()
        .then((value) {
      emit(GetFavSuccessScreen());
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (element.data()["userId"] == token) {

            favourites.add(FavouriteMovies.fromJson(element.data()));
          }
        });
      }
    }).catchError((err) {
      emit(GetFavFailScreen());
    });
  }

  Future addFavourites(int id) async
  {
    var itemId;
    itemId = FirebaseFirestore.instance
        .collection("Favourites")
        .doc()
        .id;
    return FirebaseFirestore.instance.collection("Favourites").doc(itemId)
        .set({
      "ItemId": itemId,
      "movieId": id,
      "userId": token
    });
  }

  Future removeFavourites(int id) async
  {
    var itemId;
    favourites.forEach((element) {
      if (element.movieId == id) {
        itemId = element.itemId;
        return;
      }
    });
    FirebaseFirestore.instance.collection("Favourites")
        .doc(itemId).delete().then((value){});
  }

  bool itemInFavourite = false;
  changeFav(int id) {
    print(id);
    print(favouritesMovies[id]);
    //favouritesMovies[id] = !favouritesMovies[id]!;
    emit(ChangeFavUIScreen());
    itemInFavourite = false;
    favourites.forEach((element) {
      if (element.movieId == id) {
        itemInFavourite = true;
        return;
      }
    });
    if (itemInFavourite == false) {
      addFavourites(id).then((value) {
        itemInFavourite == true;
        emit(ChangeFavSuccessScreen());
        getFavorites();
      }).catchError((err) {
        emit(ChangeFavFailScreen());
      // favouritesMovies[id] = !favouritesMovies[id]!;
      });
    }
    else {
      removeFavourites(id).then((value) {
        itemInFavourite = false;
        emit(ChangeFavSuccessScreen());
        getFavorites();
      }).catchError((err) {
        emit(ChangeFavFailScreen());
        //favouritesMovies[id] = !favouritesMovies[id]!;
      });
    }
  }

  //users
  UserModel? user;
  void signUp({
    @required String? email,
    @required String? password,
    @required String? name,
    @required String? phone,
  }) {
    emit(SignUpLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      createUser(
        email: email,
        password: password,
        name: name,
        phone: phone,
        uId: value.user?.uid,
      );
    }).catchError((err) {
    });
  }

  void createUser({
    @required String? email,
    @required String? password,
    @required String? name,
    @required String? phone,
    @required String? uId,
  }) {
    user = UserModel(
        name: name,
        email: email,
        phone: phone!,
        password: password,
        userId: uId!);
    {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(uId)
          .set(user!.toMap())
          .then((value) {
            emit(SignUpSuccess());
      })
          .catchError((err) {
        emit(SignUpError());
      });
    }
  }

  void signIn({@required email, @required password}) {
    emit(SignInLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      token= value.user?.uid;
      emit(SignInSuccess());
    }).catchError((err) {
      emit(SignInError());
    });
  }
}