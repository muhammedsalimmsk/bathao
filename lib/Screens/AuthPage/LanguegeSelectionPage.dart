import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../../Theme/Colors.dart';

class LanguageSelectionPage extends StatelessWidget {
  final String phoneNumber;
  final String name;
  final String countryCode;
  LanguageSelectionPage({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.countryCode,
  });
  final List<Map<String, dynamic>> languages = [
    {
      "title": "Arabic",
      "bgColor": Colors.red,
      "text": "العربية",
      'isSelected': false.obs,
    },
    {
      "title": "Malayalam",
      "bgColor": Colors.lightBlue,
      "text": "മ",
      'isSelected': false.obs,
    },
    {
      "title": "Tamil",
      "bgColor": Colors.black,
      "text": "அ",
      'isSelected': false.obs,
    },
    {
      "title": "Hindi",
      "bgColor": Colors.green,
      "text": "श्री",
      'isSelected': false.obs,
    },
    {
      "title": "English",
      "bgColor": Colors.blue,
      "text": "En",
      'isSelected': false.obs,
    },
  ];
  RxList<RxBool> langList =
      <RxBool>[false.obs, false.obs, false.obs, false.obs, false.obs].obs;
  final RegisterController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onBoardPrimary, AppColors.onBoardSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressBar(
                        maxSteps: 2,
                        progressType:
                            LinearProgressBar
                                .progressTypeLinear, // Use Linear progress
                        currentStep: 2,
                        progressColor: AppColors.progressBarColor,
                        backgroundColor: AppColors.progressBarBackground,
                        borderRadius: BorderRadius.circular(10), //  NEW
                      ),
                    ),
                    Text(
                      "Choose your language",
                      style: TextStyle(fontSize: 29),
                    ),
                    Text(
                      'Choose your language for a personalized experience.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: languages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final lang = languages[index];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  // Optional: single selection logic
                                  langList[index].value =
                                      !langList[index].value;
                                  if (controller.languages.contains(
                                    languages[index]['title'],
                                  )) {
                                    controller.languages.remove(
                                      languages[index]['title'],
                                    );
                                  } else {
                                    controller.languages.add(
                                      languages[index]['title'],
                                    );
                                  }
                                  print(controller.languages);
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: lang['bgColor'],
                                    border:
                                        langList[index].value
                                            ? Border.all(
                                              color: AppColors.textColor,
                                              width: 4,
                                            )
                                            : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    lang['text'],
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: lang['textColor'] ?? Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              lang['title'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.getStartBackground,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios, color: AppColors.textColor),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textColor.withOpacity(0.8),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textColor.withOpacity(0.6),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textColor.withOpacity(0.4),
                      ),
                      SizedBox(width: 10),
                      Obx(
                        () =>
                            controller.isLoading.value
                                ? CircularProgressIndicator(
                                  color: AppColors.progressBarColor,
                                )
                                : InkWell(
                                  onTap: () {
                                    controller.registerUser(
                                      name,
                                      phoneNumber,
                                      countryCode,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: AppColors.buttonGradient,
                                        begin: Alignment.topLeft,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.textColor.withValues(
                                            alpha: 0.30,
                                          ),
                                          blurRadius: 10,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
