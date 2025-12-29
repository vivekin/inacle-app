import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/models/auth_model.dart';
import 'package:inacle_app/repositories/auth_repository.dart';
import 'package:inacle_app/widgets/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPController extends GetxController {
  bool _hasError = false;
  bool get hasError => _hasError;
  String _currentText = "";
  String get currentText => _currentText;
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  final TextEditingController _textEditingController =
      TextEditingController(text: "");
  bool _isloading = false;
  bool get isloading => _isloading;

  TextEditingController get textEditingController => _textEditingController;

  changeErrorStatus(bool value) {
    log(value.toString());
    _hasError = value;
    update();
  }

  onChanged(String value) {
    _currentText = value;
    update();
  }

  goToNavigation() {
    recordLoginTime();
    Get.offAllNamed('/home');
  }

  otpValidation(context) {
    if (formKey.currentState!.validate()) {
      if (_currentText.length != 4) {
        errorController
            ?.add(ErrorAnimationType.shake); // Triggering error shake animation

        changeErrorStatus(true);
      } else {
        _isloading = true;
        update();
        UserRepository().otpValidation(otp: _currentText).then((value) {
          if (value != null) {
            LoginResponse loginResponse = LoginResponse.fromJson(value);
            if (loginResponse.status == 1) {
              // Login successful
              _isloading = false;
              update();
              UserRepository().saveLoggin();
              changeErrorStatus(false);
              CustomSnackbar.showSuccess(
                  loginResponse.message ?? 'OTP Verified');
              // snackBar("OTP Verified!!", context);
              goToNavigation();
            } else {
              _isloading = false;
              update();
              CustomSnackbar.showError(
                  title: 'Failed',
                  message: loginResponse.message ?? 'Something went wrong');
            }
          } else {
            _isloading = false;
            update();
            CustomSnackbar.showError();
          }
        });
      }

      @override
      void dispose() {
        _timer?.cancel();
        super.dispose();
      }
    }
  }

  // snackBar Widget
  snackBar(String? message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message!,
          style: const TextStyle(fontFamily: 'Roboto'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Timer? _timer;
  int _start = 30; // Start with 30 seconds
  bool _isResendButtonEnabled = true;

  Timer get timer => _timer!;
  int get start => _start;
  bool get isResendButtonEnabled => _isResendButtonEnabled;

  void startTimer() {
    _start = 30;
    resendOTP();
    _isResendButtonEnabled = false;

    _timer?.cancel(); // Cancel previous timer if running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _isResendButtonEnabled = true;
        update();
        timer.cancel(); // Stop the timer when it reaches 0
      } else {
        _start--;
        update();
      }
    });
  }

  resendOTP() {
    UserRepository()
        .resendOtp(emailID: AppConstants.user.emailID ?? '')
        .then((value) {
      if (value != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(value);
        if (loginResponse.status == 1) {
          CustomSnackbar.showSuccess(loginResponse.message ?? 'OTP Verified');
        } else {
          CustomSnackbar.showError(
              title: 'Failed',
              message: loginResponse.message ?? 'Something went wrong');
        }
      } else {
        CustomSnackbar.showError();
      }
    });
  }

  recordLoginTime() {
    UserRepository().recordLoginTime().then((value) {
      if (value != null) {
      } else {
        CustomSnackbar.showError();
      }
    });
  }
}
