import 'package:bathao/Controllers/ListenerController/ListenerController.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  // Rx list to track selected languages
  final RxList<String> selectedLanguages = <String>[].obs;
  ListenerController controller = Get.put(ListenerController());

  void toggleLanguage(String lang) {
    if (selectedLanguages.contains(lang)) {
      selectedLanguages.remove(lang);
      controller.langs.remove(lang);
      controller.refreshListeners();
    } else {
      selectedLanguages.add(lang);
      controller.langs.add(lang);
      controller.refreshListeners();
    }
  }

  bool isSelected(String lang) => selectedLanguages.contains(lang);
}
