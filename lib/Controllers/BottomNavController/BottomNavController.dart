// controllers/bottom_nav_controller.dart
import 'package:get/get.dart';

import '../AuthController/AuthController.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
