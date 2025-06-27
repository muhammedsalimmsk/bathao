import 'dart:io';

import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileImagePicker extends StatelessWidget {
  final String imageUrl =
      "https://img.freepik.com/premium-photo/arabic-man_21730-4132.jpg";

  const ProfileImagePicker({super.key}); // Replace with actual image or file

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find();
    return Row(
      children: [
        // Profile Image with edit icon (Gallery)
        Stack(
          children: [
            Obx(() {
              final File? imageFile = controller.pickedImage.value;
              return CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imageFile != null ? FileImage(imageFile) : null,
                child:
                    imageFile == null
                        ? const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        )
                        : null,
              );
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.pickFromGallery,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, size: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),

        // Camera icon
        GestureDetector(
          onTap: controller.pickFromCamera,
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7B2FF7), Color(0xFF9E52F7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}
