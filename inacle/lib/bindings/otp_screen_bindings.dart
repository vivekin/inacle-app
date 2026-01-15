import 'package:get/get.dart';
import 'package:inacle_app/controllers/otp_controller.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OTPController>(() => OTPController());
  }
}
