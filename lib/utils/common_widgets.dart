import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truck_tracker/utils/sizes_config.dart';
import 'package:truck_tracker/utils/stringsref.dart';
import 'package:velocity_x/src/extensions/string_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';

import 'app_colors.dart';
import 'app_constants.dart';
import 'common_methods.dart';
import 'enumeration_mem.dart';
import 'image_paths.dart';


class CommonUtils {
  Widget setTopNavButton(String title,{required  Function function}){
   return        SizedBox(
     width: 60.0,
     height: 50.0,
     child: TextButton(
          onPressed: () {
            ///changeAppPage(AppScreens.Home);
            function();
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.white)),
          child: title
              .text
              .maxLines(2)
              .align(TextAlign.center)
              .fontFamily(AppConstants.fontBold)
              .size(13)
              .color(Colors.black)
              .make()),
   );

  }
  Widget setHeader(String txt,
      {Color color = AppColors.header,
      double size = 22,
      TextAlign align = TextAlign.start}) {
    return txt.text
        .fontFamily(AppConstants.fontRegular)
        .fontWeight(FontWeight.w500)
        .color(color)
        .align(align)
        .size(size)

        .make();
  }
  Widget setSubHeader(String txt,
      {Color color = AppColors.white,
        double size = 17,
        TextAlign align = TextAlign.start, FontWeight fWeight = FontWeight.w500}) {
    return txt.text
        .fontFamily(AppConstants.fontRegular)
        .fontWeight(FontWeight.w500)
        .color(color)
        .align(align)
        .size(size)

        .make();
  }

  static Widget button(
      {required String title,
      required Function function,
      Color colorText = Colors.white,
        FontWeight fWeight = FontWeight.w700,
      Color color = AppColors.purpleLight,
      Color colorBorder = Colors.transparent}) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
height: 50,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(5.10, 2.0)),
            color: color,
            border: Border.all(width: 3.0, color: colorBorder)),
        alignment: Alignment.center,
        child: Padding(padding: EdgeInsets.all(4.0), child: title.text.normal.size(14).color(colorText).make().py12()),
      ).py(8),

    );
  }



  static Widget navMenuBtn(
      {required String title,
        required Function function,
        Color colorText = AppColors.base,
        Color color = AppColors.purpleLight,
        Color colorBorder = Colors.transparent}) {
    return Expanded(
      child: TextButton(
          onPressed: () {
            function();
          },
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
          child: title.text.maxLines(2).align(TextAlign.center)
              .fontFamily(AppConstants.fontBold).size(13).color(colorText).make()
      ),
    );
  }
  static Widget buttonMenu(
      {required String title,
        required Function function,
        Color colorText = Colors.black,
        Color color = AppColors.purpleLight,
        Color colorBorder = Colors.transparent}) {
    return TextButton(
      onPressed: () {
        function();
      },

      child:   title.text.semiBold.size(15).color(colorText).make()
    );
  }
static Widget menuButton(String iconLink ,String title ,[double defH =  20, double defWidth =  20] ){
 return  Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child:   Container(
            color: AppColors.base,
            height: 120,
           width: 130,


            child: Align(
              alignment: Alignment.center,
              child:  Image.asset(
                iconLink,
                width: AppSizes.w * defWidth,
                height: AppSizes.h * defH,
                // scale: 0.1,
              ),
            )
        ),
      )
    ,
     const SizedBox(height: 5,),
      title.text.color(AppColors.subHeader).fontFamily(AppConstants.fontRegular).size(16).make(),
    ],
  );
}
  static Widget baseButton(
      {required String title,
        required Function function,
        double ht = 35,
        double txtSize = 18,
        String fontType = AppConstants.fontRegular,
        Color colorText = Colors.white,
        Color color = AppColors.white,
        Color colorBorder = Colors.transparent}) {
    return SizedBox(
      width: Get.width,

      child: TextButton(

        onPressed: () {
          function();
        },
style:ButtonStyle(
  backgroundColor: MaterialStateProperty.all(AppColors.base),
),
        child:title.text.fontFamily(fontType)
            .fontWeight(FontWeight.w500)
            .color(colorText)
            .size(17).make().py0(),
       // child:CommonUtils().setHeader(title,color:AppColors.white,size: 13),
      ),
    );
  }

  static Widget baseButtonok(
      {required String title,
        required Function function,
        double ht = 35,
        double txtSize = 18,
        String fontType = AppConstants.fontRegular,
        Color colorText = Colors.white,
        Color color = AppColors.white,
        Color colorBorder = Colors.transparent}) {
    return SizedBox(
      width: Get.width,

      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30.0),
        child: TextButton(

          onPressed: () {
            function();
          },
          style:ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.base),
          ),
          child:title.text.fontFamily(fontType)
              .fontWeight(FontWeight.w500)
              .color(colorText)
              .size(17).make().py0(),
          // child:CommonUtils().setHeader(title,color:AppColors.white,size: 13),
        ),
      ),
    );
  }


  static Widget buttonGradient(
      {required String title,
      required Function function,
      Color colorText = Colors.white,
      required List<Color> color,
      Color colorBorder = Colors.transparent}) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: color,
            ),
            border: Border.all(color: colorBorder)),
        alignment: Alignment.center,
        child: title.text.semiBold.size(15).color(colorText).make().py12(),
      ).py(8),
    );
  }

  static Widget chooseBox(
      {required Function leftFunction,
      required Function rightFunction,
      required Widget rightTitle,
      required Widget leftTitle,
      required int selected}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  leftFunction();
                },
                child: Container(
                  height: 40,
                  width: Get.width * .5 - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.purple),
                    color: selected == 1 ? AppColors.purple : Colors.white,
                    boxShadow: [
                      selected == 1
                          ? BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              color: Colors.grey.shade500)
                          : const BoxShadow(),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: leftTitle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  rightFunction();
                },
                child: Container(
                  height: 40,
                  width: Get.width * .5 - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.purple),
                    color: selected == 2 ? AppColors.purple : Colors.white,
                    boxShadow: [
                      selected == 2
                          ? BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              color: Colors.grey.shade500)
                          : const BoxShadow(),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: rightTitle,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Get.width * .5 - 30 - 25,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.purple),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1),
                    // spreadRadius: 1,
                    blurRadius: 1,
                    color: Colors.grey.shade600)
              ],
            ),
            alignment: Alignment.center,
            child: "OR"
                .text
                .semiBold
                .size(18)
                .color(AppColors.purple)
                .make()
                .py12(),
          ),
        ),
      ],
    );
  }

  // static Widget hippoOffer(
  //     {required int offer, required double width, required double size}) {
  //   return Stack(
  //     children: [
  //       Image.asset(
  //         ImagePaths.hippo_offer,
  //         width: width,
  //       ),
  //       Positioned(
  //           top: 10,
  //           bottom: 10,
  //           left: 40,
  //           child: "Hippo Offer - $offer%".text.bold.size(size).white.make()),
  //     ],
  //   );
  // }

  // static Widget hippoRating({int rate = 5, double size = 24}) {
  //   return Row(
  //     children: [
  //       for (int i = 0; i < rate; i++)
  //         Image.asset(
  //           ImagePaths.hippo_icon,
  //           height: size,
  //         ),
  //     ],
  //   );
  // }

  static Widget linearProgress(double value, String text) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text.text.make(),
            "${value * 10}".text.make(),
          ],
        ).py2(),
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: value,
              color: AppColors.purple,
              backgroundColor: Colors.grey.shade500,
            )),
      ],
    ).py(8);
  }

  static Widget stepCounter(int step) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 30,
          width: Get.width * 1,
          child: Row(
            children: [
              Container(
                width: Get.width * .15,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: Get.width * .30 - 20,
                height: 5,
                decoration: BoxDecoration(
                  color: step > 1 ? AppColors.purple : AppColors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: Get.width * .30 - 20,
                height: 5,
                decoration: BoxDecoration(
                  color: step > 2 ? AppColors.purple : AppColors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: Get.width * .15,
                height: 5,
                decoration: BoxDecoration(
                  color: step > 3 ? AppColors.purple : AppColors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ],
          ),
        ),
        Positioned(left: Get.width * .15 - 10, child: circle(1, step)),
        Positioned(left: Get.width * .45 - 30, child: circle(2, step)),
        Positioned(left: Get.width * .75 - 50, child: circle(3, step)),
      ],
    );
  }

  // static Widget backButton() {
  //   return InkWell(
  //     onTap: () {
  //       Get.back();
  //     },
  //     child: Image.asset(ImagePaths.left_arrow),
  //   );
  // }

  static Widget circle(int pos, int step) {
    return Container(
      height: 20,
      width: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: step >= pos ? AppColors.purple : AppColors.grey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
            child: Visibility(
          visible: pos < step,
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 12,
          ),
        )),
      ),
    );
  }

  static String getRandString(int len) {
    var random = Random.secure();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var values =
        List.generate(len, (index) => _chars[random.nextInt(_chars.length)])
            .join();
    return values;
  }
  static  buildRow(String? title, String? data){
   return
     Container(
       margin: EdgeInsets.only(left: 30,right: 30),
       child: Row(

          children: [
       title!.text.fontFamily('Manrope').fontWeight(FontWeight.w500).color(AppColors.black).align(TextAlign.start).size(15).make(), Padding(padding: EdgeInsets.only(right: 10.0),),
            data!.text.fontFamily('Manrope').fontWeight(FontWeight.w500).color(AppColors.black).align(TextAlign.start).size(15).make(),

          ],

   ),
     );

  }
  Widget setProgressLoaderVertical(ProgressMessages msg,[Color txtColor = Colors.white, double indicatorSize = 15.0]) {
    var message = StringsRef.loading;
    switch(msg){

      case ProgressMessages.Submitting:
        message = StringsRef.submitting;
        break;
      case ProgressMessages.Loading:
      // TODO: Handle this case.
        break;
      case ProgressMessages.SigningIn:
      // TODO: Handle this case.
        break;
      case ProgressMessages.SigningOut:
      // TODO: Handle this case.
        break;
      case ProgressMessages.LoadReceive:
        message = StringsRef.loadReceive;
        break;
      case ProgressMessages.Syncing:
        message = StringsRef.syncing;
        break;
      case ProgressMessages.CheckingRedFlag:
        message = StringsRef.checkingRedFlag;
        break;
    }
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
 SizedBox(
              height: indicatorSize,
              width: indicatorSize,
              child: const CircularProgressIndicator(
                backgroundColor: Colors.red,
                strokeWidth: 1,
              ),
            ),
            const SizedBox(width: 5,),
            message
                .text
                .normal
                .size(14)
                .color(txtColor)
                .make(),
          ]),
    );
  }

 Widget setProgessLoader(ProgressMessages msg,[Color txtColor = Colors.white, double indiSize = 20.0]) {
    var message = StringsRef.loading;
    switch(msg){

      case ProgressMessages.Submitting:
        message = StringsRef.submitting;
        break;
      case ProgressMessages.Loading:
        // TODO: Handle this case.
        break;
      case ProgressMessages.SigningIn:
        // TODO: Handle this case.
        break;
      case ProgressMessages.SigningOut:
        // TODO: Handle this case.
        break;
      case ProgressMessages.LoadReceive:
        message = StringsRef.loadReceive;
        break;
      case ProgressMessages.Syncing:
        message = StringsRef.syncing;
        break;
      case ProgressMessages.CheckingRedFlag:
        message = StringsRef.checkingRedFlag;
        break;
    }
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(
              height: indiSize,
              width: indiSize,
              child: const CircularProgressIndicator(
                backgroundColor: Colors.red,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 5,),
            message
                .text
                .normal
                .size(14)
                .color(txtColor)
                .make()
          ]),
    );
  }

  Widget setProgressLayer(bool state,ProgressMessages msg){
  return   Visibility(
      visible:state,
      child: Stack(
        children: [
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
            child: SizedBox(
              height: double.infinity,
              child: CommonUtils()
                  .setProgessLoader(msg),
            ),
          ),
        ],
      ),
    );
  }

  setBaseView() {
    return  Stack(
      children: [
        Positioned(
          bottom:15,
          left: 15,
          child:Image.asset(
            ImagePaths.sliderdots,
            fit: BoxFit.scaleDown,

          ), ),
        Positioned(
          bottom:50,
          right: 15,
          child:Image.asset(
            ImagePaths.circlegp,
            fit: BoxFit.fill,
            height: 100,
            width: 100,

          ), )
      ],
    );

  }

  setBaseContainerRounded(Widget widget, [double cornerRadius = 10.0, double padding = 10.0, Alignment myAlign = Alignment.topLeft]) {
    return    Container(
        decoration: BoxDecoration(
            color: AppColors.base,
            borderRadius:
              BorderRadius.all(Radius.elliptical(cornerRadius, cornerRadius)),
            border: Border.all(
                width: 1.0, color: AppColors.base)),
        child: Center(
          child: Padding(
            padding:   EdgeInsets.all(padding),
            child: Align(alignment: myAlign, child: widget),
          ),
        ));

  }

  getNavMenuBtn(String title) {
   // final menuHeight = 40.0;
   // final spaceMenu = SizedBox(width: 3,);
    //final menuBG = DecorationImage(image:AssetImage(ImagePaths.bgTopnvBtn),fit: BoxFit.scaleDown,);
    return
    Stack(
      children: [
        Image.asset(ImagePaths.bgTopnvBtn,fit: BoxFit.scaleDown,),
        Positioned(
          top: 1,
            bottom: 1,
            left: 1,
            right: 1,

            child:
        Center(child: title.text.italic.size(14).center.make())
        )

      ],
    );



    //   Container(
    //   height: menuHeight,
    //   // width: 100,
    //   decoration: BoxDecoration(
    //
    //       image: menuBG
    //   ),
    //   child: Center(child: title.text.italic.make().p2()),
    // );
  }

  buildReferenceView(EnumReferenceType refType,String refID,{Color titleColor = AppColors.base,Color txtColor = AppColors.white,
     })  {
    var title = '';

    switch(refType){

      case EnumReferenceType.addLoad:{
        title = 'LOAD REFERENCE:';
      }
break;
      case EnumReferenceType.checkIn:
        title = 'CHECK IN - REFERENCE:';
        break;
      case EnumReferenceType.flag:
        // TODO: Handle this case.
        break;
      case EnumReferenceType.preCheckIn:
        // TODO: Handle this case.
        break;
      case EnumReferenceType.exit:
        title = 'EXIT - REFERENCE:';
        break;
      case EnumReferenceType.rejection:
        title = 'REJECTION - REFERENCE:';
        break;
    }
    return  Column(crossAxisAlignment: CrossAxisAlignment.start, children:[ Padding(
       padding: const EdgeInsets.all(8.0),
       child: CommonUtils().setHeader(title,color: titleColor),
     ),
         SizedBox(height: 10,),
         CommonUtils().setBaseContainerRounded(CommonUtils().setHeader(refID,color:txtColor,align: TextAlign.center), 10.0,10.0,Alignment.center)]);
 }

  getCommonLicenseScanButton() {

 return    Container(
      width: 200,
      height: 200,
      // margin: const EdgeInsets.all( 20),
      color: AppColors.base,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image.asset(
          ImagePaths.qrscan,
        ),
      ),
    );
  }
// static String getRandString(int len) {
//   var random = Random.secure();
//   var values = List<int>.generate(len, (i) =>  random.nextInt(255));
//   return base64UrlEncode(values);
// }
//0l

}
