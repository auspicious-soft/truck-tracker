// import 'package:camera/camera.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:truck_tracker/routes/app_pages.dart';
import 'package:truck_tracker/utils/app_constants.dart';

import 'package:truck_tracker/utils/context.dart';
import 'apis/data_class.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   Fluttertoast.showToast(msg: "Handling a background message: ${message.messageId}");
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   //print("Handling a background message: ${message.messageId}");
// }

//flutter create --org com.mrzapp mrzapp
// import 'package:camera/camera.dart';

  //List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
   // cameras = await availableCameras();
   //   CommonMethods().showToast("Total cameras ${cameras.length}");
  } catch (e) {//on CameraException
   // CommonMethods().showToast("Error in finding camera $e");
    print('Error in fetching the cameras: $e');
  }
  await Firebase.initializeApp();
 // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(
            MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => DataClass()),
                  // StreamProvider<Model2>(create: (context) => Model2()),
                  // FutureProvider<Model3>(create: (context) => Model3()),
                ],
                child:MyApp()));
      });
}
Future<void> initFB() async {
  await Firebase.initializeApp();
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}
class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.homeRoute,
      getPages: AppPages.routes,
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
