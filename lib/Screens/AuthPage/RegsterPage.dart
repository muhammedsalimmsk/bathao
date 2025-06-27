import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Screens/AuthPage/LanguegeSelectionPage.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:bathao/Widgets/ProfileImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class RegisterPage extends StatelessWidget {
  final String phone;
  RegisterPage({super.key, required this.phone});
  RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressBar(
                        maxSteps: 2,
                        progressType:
                            LinearProgressBar
                                .progressTypeLinear, // Use Linear progress
                        currentStep: 1,
                        progressColor: AppColors.progressBarColor,
                        backgroundColor: AppColors.progressBarBackground,
                        borderRadius: BorderRadius.circular(10), //  NEW
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                        ),
                      ),
                      Text(
                        'Create your account to access personalized features,',
                      ),
                      SizedBox(height: 10),
                      Text("Name"),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          } else if (value.length < 3) {
                            return "Please enter at least 3 letter";
                          }
                          return null;
                        },
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          fillColor: AppColors.textInputColor,
                          filled: true,
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Date of Birth"),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose your DOB';
                          }
                          return null;
                        },
                        controller: controller.dobController,
                        readOnly: true, // User cannot type manually
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900), // Earliest DOB allowed
                            lastDate: DateTime.now(), // No future dates
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.day.toString().padLeft(2, '0')}/"
                                "${pickedDate.month.toString().padLeft(2, '0')}/"
                                "${pickedDate.year}";
                            controller.dobController.text = formattedDate;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: AppColors.textInputColor,
                          filled: true,
                          hintText: "DD/MM/YYYY",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Gender"),
                      DropdownButtonFormField<String>(
                        iconEnabledColor: AppColors.textColor,
                        dropdownColor: AppColors.textInputColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.textInputColor,
                          hintText: "Select Gender",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                        value: null, // Initial value
                        items:
                            ["Male", "Female", "Other"]
                                .map(
                                  (gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          controller.gender = value!;
                          // Handle gender selection
                          print("Selected gender: $value");
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Profile Photo"),
                      ProfileImagePicker(),
                      SizedBox(height: 20),
                    ],
                  ),
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
                                    if (_formKey.currentState!.validate()) {
                                      // Form is valid
                                      if (controller.pickedImage.value ==
                                          null) {
                                        Get.snackbar(
                                          "Profile Pic",
                                          "Please choose an image",
                                        );
                                      } else {
                                        // Proceed only if image is picked
                                        Get.to(
                                          LanguageSelectionPage(
                                            phoneNumber: phone,
                                            name:
                                                controller.nameController.text,
                                          ),
                                        );
                                      }
                                    }
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
