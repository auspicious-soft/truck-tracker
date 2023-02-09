class ModelViewLoads {
  ModelViewLoads({
    required this.statusCode,
    required this.statusText,
    required this.message,
    required this.data,
  });

  int? statusCode;
  String? statusText;
  String? message;
  Data? data;

  ModelViewLoads.fromJson(Map<String, dynamic> json) :
    statusCode = json['status_code'],
    statusText = json['status_text'],
    message = json['message'],
    data = Data.fromJson(json['data']);

}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required  this.nextPageUrl,
    required this.path,
    required this.perPage,
    required  this.prevPageUrl,
    required this.to,
    required  this.total,
  });

  int? currentPage;
  List<Datum>? data = [];
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links = [];
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data.fromJson(Map<String, dynamic> json):

        currentPage = json['currentPage'],
        data = json['data'],
        firstPageUrl = json['firstPageUrl'],
        from = json['from'],
        lastPage = json['lastPage'],
        lastPageUrl = json['lastPageUrl'],
        links = json['links'],
        nextPageUrl = json['nextPageUrl'],
        path = json['path'],
        perPage = json['perPage'],
        prevPageUrl = json['prevPageUrl'],
        to = json['to'],
        total = json['total'];




}

class Datum {
  Datum({
    required this.id,
    required this.licenseNo,
    required this.vehicleRegNo,
    required this.dateOfExpiry,
    required this.make,
    required this.vin,
    required this.engineNo,
    required this.driverName,
    required this.driverNo,
    required this.truckId,
    required this.trailerIds,
    required  this.status,
    required  this.createdAt,
    required this.updatedAt,
    required this.trailers,
    required this.trucks,
    required  this.seals,
  });

  int? id;
  String? licenseNo;
  String? vehicleRegNo;
  String? dateOfExpiry;
  String? make;
  String? vin;
  String? engineNo;
  String? driverName;
  String? driverNo;
  String? truckId;
  String? trailerIds;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Trailer>? trailers = [];
  Trucks? trucks;
  List<Seal>? seals = [];
}

// enum LicenseNo { JX30_TGGP }
//
// enum Make { BMW }

class Seal {
  Seal({
    required this.id,
    required this.loadId,
    required this.licenseNo,
    required this.seal,
    required this.sealType,
    required this.createdAt,
    required  this.updatedAt,
  });

  int id;
  String loadId;
  String licenseNo;
  String seal;
  String sealType;
  String createdAt;
  String updatedAt;
}



class Trailer {
  Trailer({
    required this.id,
    required   this.licenseNo,
  });

  int id;
  String licenseNo;
}

class Trucks {
  Trucks({
    required  this.id,
    required this.licenseNo,
    this.description,
    required this.make,
    required this.vin,
    required this.engineNo,
    required this.dateOfExpiry,
    required this.transporterId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String licenseNo;
  dynamic description;
  String make;
  String vin;
  String engineNo;
  String dateOfExpiry;
  String transporterId;
  String createdAt;
  String updatedAt;
}



class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  String url;
  String label;
  bool active;
}
