import 'dart:developer';

import 'package:get/get.dart';
import 'package:inacle_app/repositories/auth_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
}
