import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/LanguageController/LanguageController.dart';
// Make sure to import your controller

class LanguageChips extends StatelessWidget {
  final List<String> languages;
  final void Function(List<String>)? onSelectionChanged;

  LanguageChips({super.key, required this.languages, this.onSelectionChanged});

  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              languages.map((lang) {
                final isSelected = controller.isSelected(lang);
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleLanguage(lang);
                      if (onSelectionChanged != null) {
                        onSelectionChanged!(
                          controller.selectedLanguages.toList(),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.onBoardPrimary
                                : AppColors.grayColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        lang,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.greenAccent
                                  : AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
