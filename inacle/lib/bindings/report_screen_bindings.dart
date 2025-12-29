import 'package:get/get.dart';
import 'package:inacle_app/controllers/report_controller.dart';

class ReportScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}