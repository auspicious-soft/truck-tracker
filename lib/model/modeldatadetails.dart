
class ModelDataDetails {
  String? title;
  String? data;

  // String
  ModelDataDetails(this.title, this.data);

  //constructor that convert json to object instance
  ModelDataDetails.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        data = json['data'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
    'title': title,
    'data': data,
  };
}
