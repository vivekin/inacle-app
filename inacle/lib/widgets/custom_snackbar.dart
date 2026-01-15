import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSuccess(String message) {
    Get.snackbar(
      'Success', // title
      message, // message
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: false,
      barBlur: 20,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
    );
  }

  static void showError(
      {String message = 'Something went wrong', String title = 'Error'}) {
    Get.snackbar(
      title, // title

      message, // message
      icon: const Icon(Icons.error, color: Colors.white),
      shouldIconPulse: false,
      barBlur: 20,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
    );
  }
}
