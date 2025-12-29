import 'dart:convert';

import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/models/auth_model.dart';
import 'package:inacle_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<bool> saveUser(LoginResponse user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonString = jsonEncode(user.toJson());
    return prefs.setString(AppConstants.LOGIN_RESPONSE, jsonString);
  }

  Future<LoginResponse?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(AppConstants.LOGIN_RESPONSE);
    if (jsonString == null) {
      return null;
    }

    Map<String, dynamic> userMap = jsonDecode(jsonString);
    return LoginResponse.fromJson(userMap);
  }

  // Add more methods as needed for different data operations

  Future<bool> saveLoggin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('login', true);
  }

  Future<bool?> isLoggin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isLoggin = prefs.getBool('login');
    if (isLoggin == null) {
      return null;
    }
    return isLoggin;
  }

  login(
      {required String panNo,
      required String mobNo,
      required String emailID}) async {
    try {
      final response = await _apiService.post('signup',
          body: {"panno": panNo, "mobno": mobNo, "email_id": emailID});
      // return List<Map<String, dynamic>>.from(jsonDecode(response));

      return jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  otpValidation({required String otp}) async {
    // try {
    final response = await _apiService.post('validateotp', body: {
      "unid": AppConstants.user.clientAppUnid ?? '',
      "email_id": AppConstants.user.emailID ?? '',
      "otp": otp
    });

    return jsonDecode(response);
    // } catch (e) {
    //   throw Exception('Failed to load user: $e');
    // }
  }

  resendOtp({required String emailID}) async {
    try {
      final response = await _apiService.post('resendotp', body: {
        "unid": AppConstants.user.clientAppUnid ?? '',
        "email_id": emailID
      });

      return jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  recordLoginTime() async {
    try {
      final response = await _apiService.post('loginhistory', body: {
        "unid": AppConstants.user.clientAppUnid ?? '',
        "module_name": "signin"
      });

      return jsonDecode(response);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
