class SharedModelRejection {
  String id;
  String reason;
  String imgPath;
  bool sync;

  SharedModelRejection(
      {required this.id, required this.reason, required this.imgPath, required this.sync});

  SharedModelRejection.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        reason = json['reason'],
        imgPath = json['imgPath'],
        sync = json['sync'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['imgPath'] = imgPath;
    data['sync'] = sync;

    return data;
  }
}
