import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_project/Models/cast_model.dart';
import 'package:gdsc_project/Models/favourite_model.dart';
import 'package:gdsc_project/Models/rate_model.dart';
import 'package:gdsc_project/ViewModels/Block/states.dart';
import 'package:gdsc_project/ViewModels/Network/DioHelper.dart';
import '../../Models/UserModel/UserModel.dart';
import '../../Models/movie_model.dart';
import '../Constants/constants.dart';

class MovieCubit extends Cubit<MovieStates> {
  MovieCubit() : super(MovieInitState());
  Map<int, bool> favouritesMovies = {};

  static MovieCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  //API
  MovieModel? trendingData;
  Map<int, double> rates = {};
  List<RateModel> ratesList=[];


  getTrending() {
    emit(GetTrendingLoading());
    DioHelper.getData(url: "trending/movie/day", queries: {"api_key": apiKey})
        .then((value) {
      trendingData = MovieModel.fromJson(value.data);
      trendingData?.results.forEach((element) {
        favouritesMovies.addAll({element.id!: element.inFav});
        rates.addAll({element.id!: element.rate});
      });
      getNowPlaying();
      emit(GetTrendingSuccess());
    }).catchError((err) {
      emit(GetTrendingError());
    });
  }

  MovieModel? nowPlayingData;

  getNowPlaying() {
    emit(GetNowPlayingLoading());
    DioHelper.getData(url: "movie/now_playing", queries: {"api_key": apiKey})
        .then((value) {
      nowPlayingData = MovieModel.fromJson(value.data);
      nowPlayingData?.results.forEach((element) {
        favouritesMovies.addAll({element.id!: element.inFav});
        rates.addAll({element.id!: element.rate});
      });
      getUpComing();
      emit(GetNowPlayingSuccess());
    }).catchError((err) {
      emit(GetNowPlayingError());
    });
  }

  bool loaded = false;
  MovieModel? upComingData;

  getUpComing() {
    emit(GetUpComingLoading());
    DioHelper.getData(url: "movie/upcoming", queries: {"api_key": apiKey})
        .then((value) {
      upComingData = MovieModel.fromJson(value.data);
      upComingData?.results.forEach((element) {
        favouritesMovies.addAll({element.id!: element.inFav});
        rates.addAll({element.id!: element.rate});
      });
      Timer(const Duration(seconds: 2), (() {
        loaded = true;
        getAllMovie();
        emit(GetUpComingSuccess());
      }));
    }).catchError((err) {
      emit(GetUpComingError());
    });
  }

  List<CastModel> cast = [];
  bool castLoaded = false;
  getCast(int id) {
    cast = [];
    emit(GetCastLoading());
    DioHelper.getData(url: "movie/$id/credits", queries: {"api_key": apiKey})
        .then((value) {
      value.data["cast"].forEach((element) {
        cast.add(CastModel.fromJson(element));
      });
      Timer(const Duration(seconds: 2),(){
        castLoaded = true;
        emit(GetCastSuccess());
      });
    }).catchError((err) {
      emit(GetCastError());
    });
  }


  rateMovie(double value, int id) {
    var formData = FormData.fromMap({
      "request_token": requestToken,
      "session_id": sessionId,
      "value": value
    });
    addRateToFirebase(value, id);
    emit(RateMovieLoading());
    DioHelper.postData(
            url: "movie/$id/rating",
            queries: {"api_key": apiKey},
            data: formData)
        .then((val) {
          rates[id]= value;
          getRates();
      emit(RateMovieSuccess());
    }).catchError((err) {
      emit(RateMovieError());
      print(err);
    });
  }

  addRateToFirebase(double value, int id) {
    FirebaseFirestore.instance
        .collection("Rates")
        .add({"movieId": id, "movieRate": value, "userId": token});
  }

  getRates()
  {
    FirebaseFirestore.instance.collection("Rates")
        .get().then((value){
        value.docs.forEach((element) {
          ratesList.add(RateModel.fromJson(element.data()));
        });
        print('rate');
        print(ratesList.length);
    });
  }

//Firebase
//Favourites
  List<FavouriteMovies> favourites = [];

  getAllMovie() {
    trendingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if (element.id == fElement.movieId) {
          element.inFav = true;
          favouritesMovies[element.id!]= element.inFav;
        }
      });
      ratesList.forEach((rElement) {
        if(rElement.movieId == element.id)
          {
            rates[element.id!] = element.rate;
          }
      });
    });

    upComingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if (element.id == fElement.movieId) {
          element.inFav = true;
          favouritesMovies[element.id!]= element.inFav;
        }
      });
      ratesList.forEach((rElement) {
        if(rElement.movieId == element.id)
        {
          rates[element.id!]= element.rate;
        }
      });
    });

    nowPlayingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if (element.id == fElement.movieId) {
          element.inFav = true;
          favouritesMovies[element.id!]= element.inFav;
        }
      });
      ratesList.forEach((rElement) {
        if(rElement.movieId == element.id)
        {
          rates[element.id!]= element.rate;
        }
      });
    });
    emit(ChangeFavUIScreen());
  }

  getFavorites() {
    favourites = [];
    FirebaseFirestore.instance.collection("Favourites").get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (element.data()["userId"] == token) {
            favourites.add(FavouriteMovies.fromJson(element.data()));
          }
        });
        getFavouriteMovies();
        emit(GetFavSuccessScreen());
      }
    }).catchError((err) {
      emit(GetFavFailScreen());
    });
  }

  List<MovieResult> favMovies= [];
 // List<MovieResult> uniqueFavMovies= [];
  getFavouriteMovies()
  {
    favMovies= [];
    trendingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if(element.id == fElement.movieId)
          {
            favMovies.add(element);
          }
      });
    });

    upComingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if(element.id == fElement.movieId)
        {
          favMovies.add(element);
        }
      });
    });

    nowPlayingData?.results.forEach((element) {
      favourites.forEach((fElement) {
        if(element.id == fElement.movieId)
        {
          favMovies.add(element);
        }
      });
    });

    Map<int,MovieResult> uniqueFavMovies= {};
    favMovies.forEach((element) {
      uniqueFavMovies.addAll({element.id!: element});
    });
    favMovies=[];
    uniqueFavMovies.forEach((key, value) {
      favMovies.add(value);
    });
  }

  filterFav()
  {
    favMovies.forEach((element) {
      print(element.id);
    });
  }

  Future addFavourites(int id) async {
    var itemId;
    itemId = FirebaseFirestore.instance.collection("Favourites").doc().id;
    return FirebaseFirestore.instance
        .collection("Favourites")
        .doc(itemId)
        .set({"ItemId": itemId, "movieId": id, "userId": token});
  }

  Future removeFavourites(int id) async {
    var itemId;
    favourites.forEach((element) {
      if (element.movieId == id) {
        itemId = element.itemId;
        return;
      }
    });
    FirebaseFirestore.instance
        .collection("Favourites")
        .doc(itemId)
        .delete()
        .then((value) {});
  }

  bool itemInFavourite = false;
  changeFav(int id) {
    favouritesMovies[id] = !favouritesMovies[id]!;
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
        getFavorites();
        emit(ChangeFavSuccessScreen());
      }).catchError((err) {
        emit(ChangeFavFailScreen());
        favouritesMovies[id] = !favouritesMovies[id]!;
      });
    } else {
      removeFavourites(id).then((value) {
        itemInFavourite = false;
        getFavorites();
        emit(ChangeFavSuccessScreen());
      }).catchError((err) {
        emit(ChangeFavFailScreen());
        favouritesMovies[id] = !favouritesMovies[id]!;
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
    }).catchError((err) {});
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
      }).catchError((err) {
        emit(SignUpError());
      });
    }
  }

  void signIn({@required email, @required password}) {
    emit(SignInLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      token = value.user?.uid;
      emit(SignInSuccess());
    }).catchError((err) {
      emit(SignInError());
    });
  }
}
