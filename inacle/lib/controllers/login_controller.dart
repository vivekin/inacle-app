// ignore_for_file: unnecessary_getters_setters

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/models/auth_model.dart';
import 'package:inacle_app/repositories/auth_repository.dart';
import 'package:inacle_app/routes.dart';
import 'package:inacle_app/widgets/custom_snackbar.dart';

class LoginController extends GetxController {
  String _username = '';
  String _password = '';
  bool _isObsecure = true;
  bool _isloading = false;

  String get username => _username;
  set username(String username) => _username = username;

  String get password => _password;
  set password(String password) => _password = password;

  bool get isObsecure => _isObsecure;
  set isObsecure(bool isObsecure) => _isObsecure = isObsecure;

  bool get isloading => _isloading;

  final TextEditingController panCardController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  onEmailChange(value) {
    _errorMessage = validateEmail(value) ? '' : 'Invalid email address';
    update();
  }

  bool validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void toggleObsecure() {
    isObsecure = !isObsecure;
    update();
  }

  void login() {
    if(panCardController.text.isEmpty || emailController.text.isEmpty){
      CustomSnackbar.showError( message: 'Please fill all the fields');
      return;
    }
    // Add your login logic here
    log('PanCard: ${panCardController.text}, Password: ${mobileController.text} , mobile: ${mobileController.text}');
    _isloading = true;
    update();
    UserRepository()
        .login(
            panNo: panCardController.text,
            mobNo: mobileController.text,
            emailID: emailController.text)
        .then((value) {
      if (value != null) {
        _isloading = false;
        update();
        LoginResponse loginResponse = LoginResponse.fromJson(value);
        if (loginResponse.status == 1) {
          // Login successful
          log('Login successful');
          loginResponse.emailID = emailController.text;
          UserRepository().saveUser(loginResponse);
          AppConstants.user = loginResponse;
          Get.offNamed(AppRoutes.otp);
        } else {
          // _isloading = false;
          // update();
          // Login failed
          log('Login failed');
          CustomSnackbar.showError(
              title: 'Login Failed', message: loginResponse.message ?? '');
        }
      } else {
        _isloading = false;
        update();
        CustomSnackbar.showError();
      }
    });
  }
}
