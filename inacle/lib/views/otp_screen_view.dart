import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/common/fade_animation.dart';
import 'package:inacle_app/common/hex_color.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/otp_controller.dart';
import 'package:inacle_app/repositories/auth_repository.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends GetView<OTPController> {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserRepository());
    Get.lazyPut(() => OTPController());
    return Scaffold(
      body: GetBuilder<OTPController>(builder: (otpController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.4, 0.7, 0.9],
              colors: [
                HexColor("#ffe2d0").withOpacity(0.8),
                HexColor("#ffe2d0"),
                HexColor("#a98d7c"),
                HexColor("#a98d7c"),
              ],
            ),
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
                image: const AssetImage(Images.bg)),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.white38,
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeAnimation(
                              delay: 0.8,
                              child: Image.asset(
                                Images.logo,
                                width: 200.w,
                                height: 100.h,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: Text(
                              "", //Let us help you
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Phone Number Verification',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8),
                            child: RichText(
                              text: TextSpan(
                                  text: "Enter the code sent to ",
                                  children: [
                                    TextSpan(
                                        text: "${AppConstants.user.emailID}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 15)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: otpController.formKey,
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              autoFocus: true,
                              obscureText: true,
                              obscuringCharacter: '*',
                              // obscuringWidget:  Icon(
                              //   Icons.,
                              //   color: Colors.blue[50],
                              //   size: 24,
                              // ),
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                return null;

                                // if (v!.length < 3) {
                                //   return "Validate me";
                                // } else {
                                //   return null;
                                // }
                              },
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  selectedFillColor: Colors.blue[50],
                                  activeFillColor: Colors.white,
                                  inactiveFillColor: Colors.white),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController:
                                  otpController.errorController,
                              controller: otpController.textEditingController,
                              keyboardType: TextInputType.number,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                debugPrint("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                // debugPrint(value);
                                // setState(() {
                                //   currentText = value;
                                // });
                                otpController.onChanged(value);
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              otpController.hasError
                                  ? "*Please fill up all the cells properly"
                                  : "",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (otpController.isResendButtonEnabled) {
                                    otpController.snackBar(
                                        "OTP resend!!", context);
                                    otpController.startTimer();
                                  } else {}
                                },
                                child: Text(
                                  otpController.isResendButtonEnabled
                                      ? "RESEND"
                                      : "RESEND in ${otpController.start}",
                                  style: const TextStyle(
                                      color: Color(0xFF91D3B3),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          otpController.isloading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : FadeAnimation(
                                  delay: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF632D0C),
                                          Color(0xFFAB4304)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          otpController.otpValidation(context);
                                        },
                                        style: TextButton.styleFrom(
                                            //backgroundColor: const Color(0xFF2697FF),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14.0, horizontal: 80),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0))),
                                        child: const Text(
                                          "Verify",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  //End of Center Card
                  //Start of outer card
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
