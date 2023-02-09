class ModelSubmitReport {
  String? licenseNo;
  String? vRegNo;
  String? vin;
  String? engine_no;
  String? fees;
  String? gvd;
  String? tare;
  String? make;
  String? description;
  String? expiry_date;
  String? created_at;

  ModelSubmitReport(
      this.licenseNo,
      this.vRegNo,
      this.vin,
      this.engine_no,
      this.fees,
      this.gvd,
      this.tare,
      this.make,
      this.description,
      this.expiry_date,
      this.created_at,
      );

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data  = <String , dynamic>{};
    data['licenseNo']  = licenseNo;
    data['vRegNo']  = vRegNo;
    data['vin']  = vin;
    data['engine_no']  = engine_no;
    data['fees']  = fees;
    data['gvd']  = gvd;
    data['tare']  = tare;
    data['make']  = make;
    data['description']  = description;
    data['expiry_date']  = expiry_date;
    data['created_at']  = created_at;

    return data;
  }
}
