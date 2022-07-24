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
import 'package:gdsc_project/ViewModels/Local/CacheHelper.dart';
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

  //ButtonNavigation
  int currentIndex= 0;
  changeCurrentIndex(int index)
  {
    currentIndex= index;
    emit(IndexChange());
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
    bool ratedBefore= false;
    var formData = FormData.fromMap({
      "request_token": requestToken,
      "session_id": sessionId,
      "value": value
    });
    print(ratesList.length);
    ratesList.forEach((element) {
      if(element.movieId == id)
        {
         ratedBefore = true;
        }
      else
        {
          ratedBefore = false;
        }
    });
    print(ratedBefore);
    if(ratedBefore)
      {
        updateRateFirebase(value, id);
        getRates();
      }
    else
      {
        addRateToFirebase(value, id);
        getRates();
      }
    emit(RateMovieLoading());
    DioHelper.postData(
        url: "movie/$id/rating",
        queries: {"api_key": apiKey},
        data: formData)
        .then((val) {
      rates[id]= value;
      emit(RateMovieSuccess());
    }).catchError((err) {
      emit(RateMovieError());
    });
  }

  addRateToFirebase(double value, int id) {
    String itemId= FirebaseFirestore.instance
        .collection("Rates").doc().id;
    FirebaseFirestore.instance
        .collection("Rates").doc(itemId)
        .set({"itemId": itemId, "movieId": id, "movieRate": value*2, "userId": token});
  }

  updateRateFirebase(double value, int id)
  {
    ratesList.forEach((element) {
      if(element.movieId == id && element.userId == token)
        {
          FirebaseFirestore.instance
              .collection("Rates").doc(element.itemId)
              .set({"itemId": element.itemId, "movieId": id, "movieRate": value*2, "userId": token});
        }
    });
  }

  getRates()
  {
    ratesList= [];
    FirebaseFirestore.instance.collection("Rates")
        .get().then((value){
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (element.data()["userId"] == token) {
            ratesList.add(RateModel.fromJson(element.data()));
          }
        });
      }
    });
  }

  List<MovieResult> rateMovies= [];
  getRateMovies()
  {
    rateMovies= [];
    trendingData?.results.forEach((element) {
        ratesList.forEach((rElement) {
          if(rElement.movieId == element.id)
          {
            rateMovies.add(element);
          }
        });
    });

    nowPlayingData?.results.forEach((element) {
      ratesList.forEach((rElement) {
        if(rElement.movieId == element.id)
        {
          rateMovies.add(element);
        }
      });
    });

    upComingData?.results.forEach((element) {
      ratesList.forEach((rElement) {
        if(rElement.movieId == element.id)
        {
          rateMovies.add(element);
        }
      });
    });
    Map<int,MovieResult> uniqueRateMovies= {};
    rateMovies.forEach((element) {
      uniqueRateMovies.addAll({element.id!: element});
    });
    rateMovies=[];
    uniqueRateMovies.forEach((key, value) {
      rateMovies.add(value);
    });
    rateMovies.forEach((element) {
      print(element.id);
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
          rates[element.id!] = element.rate= rElement.movieRate!;
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
          rates[element.id!] = element.rate= rElement.movieRate!;
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
          rates[element.id!] = element.rate= rElement.movieRate!;
        }
      });
    });
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

  Future addFavourites(int id) async {
    String itemId;
    itemId = FirebaseFirestore.instance.collection("Favourites").doc().id;
    return FirebaseFirestore.instance
        .collection("Favourites")
        .doc(itemId)
        .set({"ItemId": itemId, "movieId": id, "userId": token});
  }

  Future removeFavourites(int id) async {
    String? itemId;
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
      token = value.user?.uid;
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

  void getUserInfo()
  {
    emit(GetUserLoading());
    FirebaseFirestore.instance.collection("Users")
        .get().then((value){
       value.docs.forEach((element) {
         if(element.data()["userId"]== token)
           {
             user= UserModel.fromJson(element.data());
           }
       });
       emit(GetUserSuccess());
    });
  }

  void logOut()
  {
    user= null;
    CacheHelper.removeKey(key: "token");
    emit(UserLogout());
  }
}