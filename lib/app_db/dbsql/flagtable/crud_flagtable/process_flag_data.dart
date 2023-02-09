import '../../../../model/model_flag_data.dart';
import '../../../../utils/common_methods.dart';
import '../sql_flag_model.dart';

class ProcessFlagData{
  Future<List<ModelFlagData>?>  getPendingReportsData(List<Map<String, Object?>> query, String reportRef,
      String colTonTrackID, String colSealID, String colVehLicenseID, String imgPaths, String cmnt ) async {
    try {

      List<ModelFlagData> flaggedReports = [];
      //cm.showToast('Report Data $row');
      //print('Report Data $row');

      if (query.isNotEmpty) {

        for (var dataInMap in query) {
          print('row Data $dataInMap');


          final encodedUrls = dataInMap[imgPaths] as String;
          final listUrls =   CommonMethods().decodeStringInDynamicList(encodedUrls);
          print('BANNERRRRRRRR END');
          print(listUrls);

          final refID= dataInMap[reportRef] as String;
          final mComment = dataInMap[cmnt] as String;

          final idTontrack = dataInMap[colTonTrackID] as String;
          final idSeal = dataInMap[colSealID] as String;
          final idVehReg = dataInMap[colVehLicenseID] as String;

     final obj = ModelFlagData(refID: refID, tonTrackId: idTontrack,
         sealId: idSeal, veh_reg_no: idVehReg, images: listUrls, comment: mComment);


          flaggedReports.add(obj);

        } //end for loop

         if(flaggedReports.length > 0){
           return flaggedReports;
         }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      CommonMethods().showToast('Error while fetching Report Flag data $e');
      print('Error $e');
      return null;
    }
  }


}