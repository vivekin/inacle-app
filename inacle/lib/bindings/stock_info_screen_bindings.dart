import 'package:get/get.dart';
import 'package:inacle_app/controllers/stock_info_controller.dart';

class StockInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockInfoController>(() => StockInfoController());
  }
}