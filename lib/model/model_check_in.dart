class ModelCheckIn {
  String? load_id;
  String? license_no;
  String? vehicle_reg_no;
  String? make;
  String? vin;
  String? engine_no;
  String? time_stamp;
  String? gps;
  String? date_of_expiry;
  String? seal;

  ModelCheckIn(
      this.load_id,
      this.license_no,
      this.vehicle_reg_no,
      this.make,
      this.vin,
      this.engine_no,
      this.time_stamp,
      this.gps,
      this.date_of_expiry,
      this.seal,
      );

  ModelCheckIn.fromJson(Map<String, dynamic> json)
      : load_id = json['load_id'],
        license_no = json['license_no'],
        vehicle_reg_no = json['vehicle_reg_no'],
        make = json['make'],
        vin = json['vin'],
        engine_no = json['engine_no'],
        date_of_expiry = json['date_of_expiry'],
        time_stamp = json['time_stamp'],
        gps = json['gps'],
        seal = json['seal'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['load_id'] = load_id;
    data['license_no'] = license_no;
    data['vehicle_reg_no'] = vehicle_reg_no;
    data['make'] = make;
    data['vin'] = vin;
    data['engine_no'] = engine_no;
    data['date_of_expiry'] = date_of_expiry;
    data['time_stamp'] = time_stamp;
    data['gps'] = gps;
    data['seal'] = seal;

    return data;
  }
}
