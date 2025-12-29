import 'package:get/get.dart';
import 'package:inacle_app/controllers/splash_controller.dart';
import 'package:inacle_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiService());

  // Controller
  Get.lazyPut(() => SplashController());

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  return languages;
}
