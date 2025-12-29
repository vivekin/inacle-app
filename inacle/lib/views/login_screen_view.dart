import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as prov;
import 'package:inacle_app/common/fade_animation.dart';
import 'package:inacle_app/common/hex_color.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(builder: (loginController) {
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
                    surfaceTintColor: Colors.white,
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeAnimation(
                              delay: 0.2,
                              child: Image.asset(
                                Images.logo,
                                width: 200.w,
                                height: 100.h,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const FadeAnimation(
                            delay: 1,
                            child: Text(
                              "Please sign in to continue",
                              style: TextStyle(
                                  color: Colors.black, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 350.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: loginController.panCardController,
                                onTap: () {
                                  // Handle tap event if necessary
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      10), // Limit to 10 characters
                                  //FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only uppercase letters and numbers
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'[a-zA-Z0-9]')), // Allow only letters and numbers
                                  UpperCaseTextFormatter(), // Convert to uppercase
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor("#CCCCCC")),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.credit_card,
                                    size: 20,
                                  ),
                                  hintText: 'PAN Number',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  counterText:
                                      "", // Removes the max length indicator
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 350.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: loginController.mobileController,
                                onTap: () {
                                  // Handle tap event if necessary
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      10), // Limit to 10 digits
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Restrict to digits only
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor("#CCCCCC")),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.phone_outlined,
                                    size: 20,
                                  ),
                                  hintText: 'Mobile Number',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  counterText:
                                      "", // Removes the max length indicator
                                ),
                                keyboardType:
                                    TextInputType.phone, // Numeric keyboard
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 350.w,
                              height: 76.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: loginController.emailController,
                                    onTap: () {
                                      // Handle tap event if necessary
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 16.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor("#CCCCCC")),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        size: 20,
                                      ),
                                      //errorText:loginController.errorMessage,
                                      hintText: 'Email',
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      counterText:
                                          "", // Removes the max length indicator
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    onChanged: (value) {
                                      loginController.onEmailChange(value);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          loginController.isloading
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
                                        FocusScope.of(context).unfocus();
                                        loginController.login();
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14.0, horizontal: 80),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                      ),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  //End of Center Card
                  //Start of outer card
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: false,
                    child: FadeAnimation(
                      delay: 1,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text("Forgot Password?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: newValue.text.toUpperCase(),
//       selection: newValue.selection,
//     );
//   }
// }

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
