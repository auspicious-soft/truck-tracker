class DataToken{
  // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}
  String token;
 String user_id;
  DataToken({required this.token, required this.user_id });

  factory DataToken.fromJson(Map<String,dynamic> data){
    final token = data['token'] as String;
    final user_id = data['user_id'] as String;
    return DataToken(token: token,user_id:user_id);
  }
}