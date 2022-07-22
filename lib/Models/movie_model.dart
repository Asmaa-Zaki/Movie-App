class MovieModel
{
  int? page;
  int? totalPages;
  int? totalResults;
  List<MovieResult> results= [];

  MovieModel.fromJson(Map<String, dynamic> data)
  {
    page= data["page"];
    data["results"].forEach((element){
      results.add(MovieResult.fromJson(element));
    });
    totalPages= data["total_pages"];
    totalResults= data["total_results"];
  }
}

class MovieResult
{
  bool? adult;
  String? backdropPath;
  int? id;
  String?  title;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  String? poster;
  String? mediaType;
  List<dynamic>? genreIds;
  dynamic popularity;
  String? releaseDate;
  bool? video;
  dynamic voteAverage;
  int? voteCount;
  bool inFav= false;
  double rate= 0;

  MovieResult.fromJson(Map<String, dynamic> data)
  {
    adult= data["adult"];
    backdropPath= data["backdrop_path"];
    id= data["id"];
    title= data["title"];
    originalLanguage= data["original_language"];
    originalTitle= data["original_title"];
    overview= data["overview"];
    poster= data["poster_path"];
    mediaType= data["media_type"];
    genreIds= data["genre_ids"];
    popularity= data["popularity"];
    releaseDate= data["release_date"];
    video= data["video"];
    voteAverage= data["vote_average"];
    voteCount= data["vote_count"];
  }
}
