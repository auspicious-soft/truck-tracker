
class ModelLicenseData {

  String? number;
  String? licenseno;
  String? vehregno;
  String? vin;
  String? engineno;
  String? fees;
  String? gvd;
  String? tare;
  String? make;
  String? description;
  String? dateoftest;
  String? persons;
  String? seated;
  String? expirydate;

  // String
  ModelLicenseData(
      this.number,
      this.licenseno,
      this.vehregno,
      this.vin,
      this.engineno,
      this.fees,
      this.gvd,
      this.tare,
      this.make,
      this.description,
      this.dateoftest,
      this.persons,
      this.seated,
      this.expirydate);

  //constructor that convert json to object instance
  ModelLicenseData.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        licenseno = json['licenseno'],
        vehregno = json['vehregno'],
        vin = json['vin'],
        engineno = json['engineno'],
        fees = json['fees'],
        gvd = json['gvd'],
        tare = json['tare'],
        make = json['make'],
        description = json['description'],
        dateoftest = json['dateoftest'],
        persons = json['persons'],
        seated = json['seated'],
        expirydate = json['expirydate'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
    'number': number,
    'licenseno': licenseno,
    'vehregno': vehregno,
    'vin': vin,
    'engineno': engineno,
    'fees': fees,
    'gvd': gvd,
    'tare': tare,
    'make': make,
    'description': description,
    'dateoftest': dateoftest,
    'persons': persons,
    'seated': seated,
    'expirydate': expirydate
  };
}
