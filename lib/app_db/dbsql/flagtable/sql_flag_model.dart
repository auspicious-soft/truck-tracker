class SQLModelFlag {
  int id = 0;
  String? tonTrackData;
  String? tonTrackID;
  String? sealData;
  String? sealID;
  String? vehData;
  String? vehID;
  List<dynamic>? imageUrls;
  String? comment;
  String? reportRef;
  String? createdAt;
  int sync = 0;

  SQLModelFlag(
      {required this.id,
      required this.tonTrackData,
      required this.tonTrackID,
      required this.sealData,
      required this.sealID,
      required this.vehData,
      required this.vehID,
      required this.imageUrls,
      required this.comment,
      required this.reportRef,
      required this.createdAt,
      required this.sync});

  SQLModelFlag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tonTrackData = json['tonTrackData'];
    tonTrackID = json['tonTrackID'];
    sealData = json['sealData'];
    sealID = json['sealID'];
    vehData = json['vehData'];
    vehID = json['vehID'];
    imageUrls = json['imageUrls'];
    comment = json['comment'];
    reportRef = json['reportRef'];
    createdAt = json['createdAt'];
    sync = json['sync'];
  }
}
