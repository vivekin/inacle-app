import 'dart:developer';

import 'package:get/get.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/repositories/auth_repository.dart';
import 'package:inacle_app/repositories/home_repository.dart';
import 'package:inacle_app/routes.dart';

class SplashController extends GetxController {
  final String _version = '1.2.0';

  String get version => _version;

  @override
  void onInit() {
    super.onInit();
    log('SplashController initialized');
  }

  fetchUserInfo() async {
    await UserRepository().isLoggin().then((value) {
      if (value != null) {
        AppConstants.isLoggin = value;
        log('isLoggin: ${AppConstants.isLoggin}');
      }
    });

    await UserRepository().getUser().then((value) {
      if (value != null) {
        AppConstants.user = value;
        log('User: ${AppConstants.user.toJson()}');
      }
    });

    await HomeRepository().getAgentsList().then((value) {
      if (value != null) {
        AppConstants.agentList = value;
        log('agentList: ${AppConstants.agentList}');
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    // Navigate to the login screen after a delay
    log('OnReady');
    Get.lazyPut(() => UserRepository());
    await fetchUserInfo();
    Future.delayed(const Duration(seconds: 3), () {
      if (AppConstants.isLoggin == false) {
        Get.offNamed(AppRoutes.login);
      } else {
        Get.offNamed(AppRoutes.home);
      }
    });
  }
}
