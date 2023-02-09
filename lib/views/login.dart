import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:truck_tracker/apis/data_class.dart';
import 'package:truck_tracker/controller/login_controller.dart';
import 'package:truck_tracker/utils/sizes_config.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/common_widgets.dart';
import '../utils/image_paths.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final LoginController _controller = LoginController();
  final fontHeading = AppConstants.fontHeading;
  final fontSubHeading = AppConstants.fontHeading;
  final spaceV = const SizedBox(
    height: 10,
  );
  final spaceV2 = const SizedBox(
    height: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.baseBg,
      body: SafeArea(
        child:Stack(
          children: [
            CommonUtils().setBaseView(),
            _buildLoginBody()
          ],
        )
      ),
    );

  }

_buildLoginBody(){
    return  Consumer<DataClass>(builder: (context, data, child) {
      return data.loading
          ?Center(
        child: Container(
          height: double.infinity,
          color: Colors.black87,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
                ' Signing.....'
                    .text
                    .normal
                    .size(14)
                    .color(Colors.white)
                    .make()
              ]),
        ),
      )
          : SingleChildScrollView(
        child: Form(
          key: _controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),

                    Center(
                      child: Image.asset(
                        ImagePaths.logoBlue,
                        width: AppSizes.w * 60,
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    formFiledSecond(context),
                    spaceV,
                    CommonUtils.baseButton(
                        title: "Login",
                        function: () {
                          _controller.signIn(context);
                        },
                        colorBorder: AppColors.black),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
}
  Widget formFiledSecond(BuildContext context) {
    const borderStyle = BorderSide(color: AppColors.base, width: 1.5);
    const hintStyle = TextStyle(
      color: AppColors.base,
      fontSize: 17,
      fontFamily: AppConstants.fontRegular,
      // fontStyle: FontStyle.normal,
      // fontWeight: FontWeight.w500,
    );
    const typeStyle = TextStyle(
        fontSize: 15.0,
        color: AppColors.base,
        fontFamily: AppConstants.fontSubTitle,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          style: typeStyle,
          cursorColor: Colors.black,
          inputFormatters: [
            FilteringTextInputFormatter.deny(' '),
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9.-@]')),
          ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

            filled: true,
            fillColor: AppColors.white,
            hintStyle: hintStyle,
            hintText: 'Username',

            errorBorder: OutlineInputBorder(
              borderSide: borderStyle,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: borderStyle,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: borderStyle,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: borderStyle,
            ),
            border: OutlineInputBorder(
              borderSide: borderStyle,
            ),
          ),
          validator: (value) {
            return _controller.handleEmail(value!);
          },
        ),
        spaceV,
        Obx(
          () => TextFormField(
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            style: typeStyle,
            cursorColor: Colors.black,
            inputFormatters: [FilteringTextInputFormatter.deny(' ')],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: _controller.passwordBool.value,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              // contentPadding:
              // EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              filled: true,
              // suffixStyle:   TextStyle(color: AppColors.grey),
              // suffixIcon: Obx(
              //       () => GestureDetector(
              //     onTap: () {
              //       _controller.passwordBool.value =
              //       !_controller.passwordBool.value;
              //     },
              //     child: _controller.passwordBool.value
              //         ? SizedBox(
              //       width: 10,
              //       height: 10,
              //       child: Icon(
              //
              //         Icons.visibility_off,
              //         color: Colors.grey.shade400,
              //       ),
              //     )
              //         :SizedBox(
              //       width: 10,
              //       height: 10,
              //       child: Icon(
              //         Icons.visibility,
              //         color: Colors.grey.shade400,
              //       ),
              //     ),
              //   ),
              // ),
              //
              fillColor: AppColors.white,
              hintStyle: hintStyle,
              hintText: 'Password',
              errorBorder: OutlineInputBorder(
                borderSide: borderStyle,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: borderStyle,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: borderStyle,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: borderStyle,
              ),
              border: OutlineInputBorder(
                borderSide: borderStyle,
              ),
            ),
            validator: (value) {
              return _controller.handlePassword(value!);
            },
            onFieldSubmitted: (value) {
              // Fluttertoast.showToast(msg: 'jkjj');
              _controller.signIn(context);
              // _controller.handlePassword(value);
            },
          ),
        ),
      ],
    );
  }

}
