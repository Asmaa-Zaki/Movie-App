class RateModel
{
  double? movieRate;
  int? movieId;
  String? userId;

  RateModel.fromJson(Map<String, dynamic> data)
  {
    movieRate= data["movieRate"];
    movieId= data["movieId"];
    userId= data["userId"];
  }
}