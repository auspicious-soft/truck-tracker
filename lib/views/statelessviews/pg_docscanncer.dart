import 'package:flutter/material.dart';
// import '../../utils/app_screens.dart';
// import 'dart:io';
//
// import 'package:document_scanner_flutter/document_scanner_flutter.dart';
// import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:document_scanner/document_scanner.dart';
class PgDocScanner extends   StatefulWidget {
 _PgDocScannerState createState() => _PgDocScannerState();

}
class _PgDocScannerState extends State<PgDocScanner> {
 // PDFDocument? _scannedDocument;
 //  File? _scannedDocumentFile;
 //  File? _scannedImage;

  @override
  Widget build(BuildContext context) {
    // HomeController _controller = Get.find();

    return Scaffold(
      appBar: AppBar(backgroundColor:Colors.blueAccent ,),
      body: SafeArea(child: TextButton(onPressed: (){}, child: Text('open'))
      ),
    ) ;

  }

 // void openPdfScanner(BuildContext context) async {
 //    var doc = await DocumentScannerFlutter.launchForPdf(
 //      context,
 //      labelsConfig: {
 //        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Steps",
 //        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "Only 1 Page",
 //        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
 //        "Only {PAGES_COUNT} Page"
 //      },
 //      //source: ScannerFileSource.CAMERA
 //    );
 //    if (doc != null) {
 //      // _scannedDocument = null;
 //      // setState(() {});
 //      // await Future.delayed(Duration(milliseconds: 100));
 //      // _scannedDocumentFile = doc;
 //      // _scannedDocument = await PDFDocument.fromFile(doc);
 //      // setState(() {});
 //    }
 //  }
 //
 //  openImageScanner(BuildContext context) async {
 //    var image = await DocumentScannerFlutter.launch(context,
 //        //source: ScannerFileSource.CAMERA,
 //        labelsConfig: {
 //          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
 //          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
 //        });
 //    if (image != null) {
 //      _scannedImage = image;
 //      setState(() {});
 //    }
 //  }

  //
  // _buildScannerB(){
  //   return Stack(
  //     children: <Widget>[
  //       Column(
  //         children: <Widget>[
  //           Expanded(flex: 1,
  //             child: DocumentScanner(
  //               // documentAnimation: false,
  //               noGrayScale: true,
  //               onDocumentScanned:
  //                   (ScannedImage scannedImage) {
  //                 print("document : " +
  //                     scannedImage.croppedImage!);
  //
  //                 // setState(() {
  //                 //   scannedDocument = scannedImage
  //                 //       .getScannedDocumentAsFile();
  //                 //   // imageLocation = image;
  //                 // });
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //       // scannedDocument != null
  //       //     ? Positioned(
  //       //   bottom: 20,
  //       //   left: 0,
  //       //   right: 0,
  //       //   child: ElevatedButton(
  //       //       child: Text("retry"),
  //       //       onPressed: () {
  //       //         setState(() {
  //       //           scannedDocument = null;
  //       //         });
  //       //       }),
  //       // )
  //       //     : Container(),
  //     ],
  //
  //   );
  // }
  // _buildScanner(){
  //   return Stack(
  //     children: <Widget>[
  //       Column(
  //         children: <Widget>[
  //           Expanded(flex: 1,
  //             child: DocumentScanner(
  //               // documentAnimation: false,
  //               noGrayScale: true,
  //               onDocumentScanned:
  //                   (ScannedImage scannedImage) {
  //                 print("document : " +
  //                     scannedImage.croppedImage!);
  //
  //                 // setState(() {
  //                 //   scannedDocument = scannedImage
  //                 //       .getScannedDocumentAsFile();
  //                 //   // imageLocation = image;
  //                 // });
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //       // scannedDocument != null
  //       //     ? Positioned(
  //       //   bottom: 20,
  //       //   left: 0,
  //       //   right: 0,
  //       //   child: ElevatedButton(
  //       //       child: Text("retry"),
  //       //       onPressed: () {
  //       //         setState(() {
  //       //           scannedDocument = null;
  //       //         });
  //       //       }),
  //       // )
  //       //     : Container(),
  //     ],
  //
  //   );
  // }
}