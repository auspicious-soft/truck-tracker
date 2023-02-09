import 'package:flutter/material.dart';
import 'package:truck_tracker/utils/app_colors.dart';
import 'package:truck_tracker/utils/app_constants.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/image_paths.dart';
import '../utils/sizes_config.dart';

//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
//flutter build apk --split-per-abi
class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

//final _controller = SplashScreenController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset(
              ImagePaths.logoWhite,
              width: AppSizes.w * 60,
            ),
            const SizedBox(
              height: 200,
            ),
        'Loading...'.text
              .fontFamily(AppConstants.fontRegular)
              // .fontWeight(FontWeight.w700)
             .color(AppColors.white)
             // .align(align)
              .size(22)
              .make()
           // CommonUtils().setHeader( 'Loading...',color: AppColors.white)

          ],
        ),
      ),
    );
  }
}

/*
* StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(ImagePaths.logo, width: AppSizes.w*40,),
                  const SizedBox(height: 80,),
                  '...loading'.text.semiBold.center.size(AppSizes.basetext).make().py12(),
                ],
              ),
            );
          }
          else if(snapshot.hasError){
            Fluttertoast.showToast(msg: 'Something went wrong.');
            return Login();
          }
         else  if(snapshot.hasData){
            return  NavigationDashBoard();
          }else{
           // final done = await _controller.goto();
            return Login();
          }
        },

      ),*/
