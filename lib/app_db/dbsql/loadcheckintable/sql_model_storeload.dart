
class SqlModelStoreLoad {
 int id = 0;
String? loadID;
  String? license_no;
  String? vehicle_reg_no;
  String? make;
  String? vin;
  String? engine_no;
  String? date_of_expiry;
  String? driver_name;
  String? driver_no;
  String? updated_at;
  String? created_at;
  String? seal;
  String? trailer;
  String? ref_id;

  SqlModelStoreLoad(
      this.id,
      this.loadID,
      this.license_no,
      this.vehicle_reg_no,
      this.make,
      this.vin,
      this.engine_no,
      this.date_of_expiry,
      this.driver_name,
      this.driver_no,
      this.updated_at,
      this.created_at,
      this.seal,
      this.trailer,
      this.ref_id,
      );
  SqlModelStoreLoad.fromJson(Map<String,dynamic> json)
      :id = json['id'],
        loadID = json['loadID'],
        license_no = json['license_no'],
        vehicle_reg_no = json['vehicle_reg_no'],
        make = json['make'],
        vin = json['vin'],
        engine_no = json['engine_no'],
        date_of_expiry = json['date_of_expiry'],
        driver_name = json['driver_name'],
        driver_no = json['driver_no'],
        updated_at = json['updated_at'],
        created_at = json['created_at'],
        seal = json['seal'],
        trailer = json['trailer'],
  ref_id = json['ref_id'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['loadID'] = loadID;
    data['license_no'] = license_no;
    data['vehicle_reg_no'] = vehicle_reg_no;
    data['make'] = make;
    data['vin'] = vin;
    data['engine_no'] = engine_no;
    data['date_of_expiry'] = date_of_expiry;
    data['driver_name'] = driver_name;
    data['driver_no'] = driver_no;
    data['updated_at'] = updated_at;
    data['created_at'] = created_at;
    data['seal'] = seal;
    data['trailer'] = trailer;
data['ref_id'] = ref_id;
    return data;
  }
}
