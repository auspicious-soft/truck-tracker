import 'dart:ui';
import 'package:velocity_x/velocity_x.dart';

class AppConstants{
  static const String appName = 'Trucker Track';
  static const String fontRegular = 'Poppins-Regular';//'josefinSans';//'josefinSans'
  static const String fontMedium = 'Poppins-Medium';//'josefinSans';//'josefinSans'
  static const String fontBold = 'Poppins-Bold';//'josefinSans';//'josefinSans'
  static const String fontHeading = 'Poppins-Regular';//'josefinSans';//'josefinSans'
  static const String subHeading = 'Poppins-Medium';//'josefinSans';//'josefinSans'
  static VxTextBuilder  fonth = ''.text.fontFamily(fontHeading).fontWeight(FontWeight.w700);
  static const String fontSubTitle = 'Poppins-Regular';
  static const boxName = 'truck_box';

  static bool InDebug  = true;

}