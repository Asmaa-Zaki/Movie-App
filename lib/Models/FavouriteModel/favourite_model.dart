class FavouriteMovies
{
  String? itemId;
  int? movieId;
  String? userId;

  FavouriteMovies.fromJson(Map<String, dynamic> data)
  {
    itemId= data["ItemId"];
    movieId= data["movieId"];
    userId= data["userId"];
  }
}