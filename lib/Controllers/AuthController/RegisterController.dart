import 'dart:io';

import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Models/user_model.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Widgets/MainPage/MainPage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? jwsToken;

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final ApiService _apiService = ApiService();
  late UserModel model = UserModel();
  AuthController controller=Get.put(AuthController());
  String gender = '';
  String phone = '';
  String dob = '';
  final ImagePicker _picker = ImagePicker();
  var pickedImage = Rxn<File>();
  List<String> languages = [];
  var isLoading = false.obs;

  // Pick from gallery
  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  // Pick from camera
  Future<void> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  Future registerUser(String name, String number) async {
    final endpoint = 'api/v1/user/register';

    // Check if profile image is picked
    if (pickedImage.value == null) {
      print("No profile image selected.");
      return;
    }
    final data = {
      "name": name,
      "gender": gender.toLowerCase(),
      "dateOfBirth":
          dobController
              .text, // Assuming you meant dateOfBirth, not gender twice
      "phone": number,
      "profilePic": pickedImage.value,
      'langs': languages, // Important: This must be a File
    };
    isLoading.value = true;

    try {
      final response = await _apiService.postRequest(
        endpoint,
        data,
        isMultipart: true,
      );
      if (response.isOk) {
        model = UserModel.fromJson(response.body);
        final prefs = await SharedPreferences.getInstance();
        jwsToken = model.token;
        await prefs.setString('token', model.token!);
        print("Registered successfully");
        await controller.getUserData();

        Get.offAll(MainPage());
      } else {
        print("Failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Exception in registerUser: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
