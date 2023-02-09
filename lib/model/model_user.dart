class ModelUser{
  // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}
  String token;
  int user_id;
  ModelUser({required this.token, required this.user_id });

  factory ModelUser.fromJson(Map<String,dynamic> data){
    final token = data['token'] as String;
    final user_id = data['user_id'] as int;
    return ModelUser(token: token,user_id:user_id);
  }
}