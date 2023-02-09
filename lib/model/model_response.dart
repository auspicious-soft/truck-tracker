class ModelResponse {
  bool flagError;
  bool flagSuccess;
  dynamic data;


  // String
  ModelResponse(this.flagError, this.flagSuccess,this.data);

  //constructor that convert json to object instance
  ModelResponse.fromJson(Map<String, dynamic> json)
      : flagError = json['flagError'],
        flagSuccess = json['flagSuccess'],
        data = json['data'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
    'flagError': flagError,
    'flagSuccess':flagSuccess,
    'data': data

  };
}

//flutter packages pub run build_runner build
