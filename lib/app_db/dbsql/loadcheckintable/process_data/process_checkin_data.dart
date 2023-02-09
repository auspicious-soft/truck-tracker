import 'package:truck_tracker/utils/common_methods.dart';
import '../../../../model/model_reject_sql.dart';

class ProcessCheckInData {
  Future<List<ModelCheckInRejectionSql>?> getPendingRejectionData(List<Map<String, Object?>> query, String mrefID, String columnRejectionReason, String columnRejectionPhotoLink) async {
    try {
      List<ModelCheckInRejectionSql> model = [];
      query.forEach((data) {
       final reason = data[columnRejectionReason] as String;
       final photoLink = data[columnRejectionPhotoLink] as String;
       final refID = data[mrefID] as String;
       final obj = ModelCheckInRejectionSql(reason: reason, refID: refID, photoLink: photoLink);
       model.add(obj);
      });
if(model.length > 0){
  return model;
}else{
  return null;
}

    } catch (e) {
      print(e);
     CommonMethods().showToast('Exception during getPendingRejectionData $e');
      return null;

    }

  }
}