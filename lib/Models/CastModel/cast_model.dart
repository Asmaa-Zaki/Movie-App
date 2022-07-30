class CastModel
{
  String? name;
  String? profilePath;

  CastModel.fromJson(Map<String, dynamic> data)
  {
   name= data["name"];
   profilePath= data["profile_path"];
  }
}