class ErrorData{
 // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}
  String message;
  ErrorData({required this.message});

  factory ErrorData.fromJson(Map<String,dynamic> data){
    final _msg = data['message'] as String;
    return ErrorData(message: _msg);
  }
}