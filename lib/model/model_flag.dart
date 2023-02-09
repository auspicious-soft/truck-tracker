class ModelFlag {
  int? statusCode;
  String? statusText;
  String? message;
  FlagDetail? flagDetail;
//{"status_code":0,"status_text":"Failed","message":"no load found for this license id","flag_detail":null}
  ModelFlag({required this.statusCode, required this.statusText, required this.message, required this.flagDetail});

  ModelFlag.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusText = json['status_text'];
    message = json['message'];
    flagDetail = json['flag_detail'];
      // (
      //   != null
      //   ? FlagDetail.fromJson(json['flag_detail'])
      //   : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status_text'] =  statusText;
    data['message'] =  message;
    if (flagDetail != null) {
      data['flag_detail'] = flagDetail?.toJson();
    }
    return data;
  }
}

class FlagDetail {
  int? id;
  String? tontrack;
  String? seal;
  String? vehRegNo;
  String? image;
  String? comment;
  int? loadId;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  FlagDetail(
      {required this.id,
        required this.tontrack,
        required  this.seal,
        required this.vehRegNo,
        required this.image,
        required this.comment,
        required  this.loadId,
        required  this.createdAt,
        required  this.updatedAt,
        required  this.imageUrl});

  FlagDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tontrack = json['tontrack'];
    seal = json['seal'];
    vehRegNo = json['veh_reg_no'];
    image = json['image'];
    comment = json['comment'];
    loadId = json['load_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    data['id'] =   id;
    data['tontrack'] =  tontrack;
    data['seal'] =  seal;
    data['veh_reg_no'] =  vehRegNo;
    data['image'] =  image;
    data['comment'] =  comment;
    data['load_id'] =  loadId;
    data['created_at'] =  createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] =  imageUrl;
    return data;
  }
}
