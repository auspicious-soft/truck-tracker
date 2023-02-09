
class ModelLoad {
  String? load;
  String? lastcheck;
  String? vehicle;
  int status;

  // String
  ModelLoad(this.load,  this.lastcheck, this.vehicle, this.status);

  //constructor that convert json to object instance
  ModelLoad.fromJson(Map<String, dynamic> json)
      : load = json['load'],
        lastcheck = json['lastcheck'],
        vehicle = json['vehicle'],
        status = json['status'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
    'load': load,
    'lastcheck': lastcheck,
    'vehicle': vehicle,
    'status': status,
  };
}

//flutter packages pub run build_runner build
