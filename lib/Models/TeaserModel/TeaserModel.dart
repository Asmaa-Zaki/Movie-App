class TeaserModel
{
  int? id;
  List<Result> results= [];

  TeaserModel.fromJson(Map<String, dynamic> data)
  {
    id= data["id"];
    data["results"].forEach((element){
      results.add(Result.fromJson(element));
    });
  }
}
class Result
{
  String? key;
  String? type;

  Result.fromJson(Map<String, dynamic> data)
  {
    key= data["key"];
    type= data["type"];
  }
}