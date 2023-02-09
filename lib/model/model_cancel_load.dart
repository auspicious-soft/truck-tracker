class ModelCancelLoad {
  String id;
  String reason;
  ModelCancelLoad(  this.id,   this.reason);

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data  = <String , dynamic>{};
    data['id']  = id;
    data['reason']  = reason;
   return data;
  }
}