import 'package:truck_tracker/model/model_vehicle_license.dart';

import 'model_license_data.dart';

class TransferSealData {
  final ModelLicenseData vehLicenData;
  final String trialers;
  final String surname;
  final String driverName;
  final String driverNo;
  TransferSealData(this.vehLicenData, this.trialers, this.surname,this.driverName,this.driverNo);
}