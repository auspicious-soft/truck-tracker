class ModelSignIn{
  String username;
  String password;
  String devicename;
  ModelSignIn({
    required this.username,
    required this.password,
    required this.devicename
  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data  = <String , dynamic>{};
    data['username']  = username;
    data['password']  = password;
    data['device_name']  = devicename;
    return data;
  }
}