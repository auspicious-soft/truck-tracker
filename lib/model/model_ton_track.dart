
class ModelTonTrackData {
// int id = 0;
  String? ticketNo;
  String? ticketGenTimeStamp;
  String? source;
  String? destination;
  String? grossMass;
  String? netMass;
  String? hauiler;
  String? driver_name;

  String? vehReg;
  String? supplier;


  ModelTonTrackData(
      this.ticketNo,
      this.ticketGenTimeStamp,
      this.source,
      this.destination,
      this.grossMass,
      this.netMass,
      this.hauiler,
      this.driver_name,
      this.vehReg,
      this.supplier,

      );
  ModelTonTrackData.fromJson(Map<String,dynamic> json)
      : ticketNo = json['ticketNo'],
        ticketGenTimeStamp = json['ticketGenTimeStamp'],
        source = json['source'],
        destination = json['destination'],
        grossMass = json['grossMass'],
        netMass = json['netMass'],
        hauiler = json['hauiler'],
        driver_name = json['driver_name'],
        vehReg = json['vehReg'],
        supplier = json['supplier'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticketNo'] = ticketNo;
    data['ticketGenTimeStamp'] = ticketGenTimeStamp;
    data['source'] = source;
    data['destination'] = destination;
    data['grossMass'] = grossMass;
    data['netMass'] = netMass;
    data['hauiler'] = hauiler;
    data['driver_name'] = driver_name;
    data['vehReg'] = vehReg;
    data['supplier'] = supplier;

    return data;
  }
}
