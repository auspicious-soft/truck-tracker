import '../app_db/dbsql/loadcheckintable/sql_model_storeload.dart';

class TransferCheckInVehData {
  final SqlModelStoreLoad vehLicenData;
  final String timeStamp;
  final String gps;
  final String lastLoadID;

  TransferCheckInVehData(
      this.vehLicenData, this.timeStamp, this.gps, this.lastLoadID);
}
