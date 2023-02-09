import 'package:truck_tracker/utils/common_methods.dart';
import '../../../../model/model_reject_sql.dart';

class ProcessLoadData {
  Future<List<String>?> getDriverNameAndLicenseNo(List<Map<String, Object?>> query, String mLicenseNo, String mDriverName
      ) async {
    try {
      List<ModelCheckInRejectionSql> model = [];
      List<String> nameList = [];
    if (query.isNotEmpty) {
      for (var dataInMap in query) {
        final lno = dataInMap[mLicenseNo] as String;
        final name = dataInMap[mDriverName] as String;

        nameList.add(name);
        nameList.add(lno);
      }
      if(nameList.length > 0){
        return nameList;
      }

      return nameList;
    } else {
      return null;
    }

    } catch (e) {
      print(e);
      CommonMethods().showToast('Exception during getDriverNameAndLicenseNo $e');
      return null;

    }

  }
}