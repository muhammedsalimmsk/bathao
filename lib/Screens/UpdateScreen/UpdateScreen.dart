import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/AuthController/AuthController.dart';
import '../../Theme/Colors.dart';

class UpdateAppScreen extends StatelessWidget {
  const UpdateAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.onBoardSecondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.system_update, color: Colors.white, size: 80),
            const SizedBox(height: 20),
            const Text(
              'A new version of the app is available.\nPlease update to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                print(controller.updateUrl);
                final url = Uri.parse(controller.updateUrl ?? '');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar("Error", "Could not open the update link");
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }
}
