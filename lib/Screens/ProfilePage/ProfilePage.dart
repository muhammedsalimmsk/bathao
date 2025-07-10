import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Screens/AuthPage/LoginPage.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Column(
        children: [
          // Header Section
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.onBoardPrimary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      '$baseImageUrl${userModel!.user!.profilePic}',
                    ), // Replace with your image
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel!.user!.name!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userModel!.user!.phone!,
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Info Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  icon: Icons.privacy_tip,
                  label: "Privacy Policy",
                  onTap: () {
                    launchPrivacy();
                    // Navigate to Privacy Policy page
                  },
                ),
                _buildActionTile(
                  icon: Icons.support_agent,
                  label: "Get Support",
                  onTap: () {
                    sendEmail();
                    // Open email or support chat
                  },
                ),
                _buildActionTile(
                  icon: Icons.info_outline,
                  label: "About Us",
                  onTap: () {
                    launchAbout();
                    // Navigate to About page
                  },
                ),
                _buildActionTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.remove('token');
                    Get.offAll(LoginPage());
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Logout button
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          //   child: ElevatedButton.icon(
          //     onPressed: () async {
          //       SharedPreferences pref = await SharedPreferences.getInstance();
          //       pref.remove('token');
          //       Get.offAll(LoginPage());
          //     },
          //     icon: const Icon(Icons.logout),
          //     label: const Text("Logout"),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColors.onBoardPrimary,
          //       foregroundColor: Colors.white,
          //       minimumSize: const Size.fromHeight(50),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onBoardSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.progressBarColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.onBoardSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.progressBarColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchPrivacy() async {
    final Uri url = Uri.parse('https://bathaocalls.com/privacy_policy.html');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchAbout() async {
    final Uri url = Uri.parse('https://bathaocalls.com/#about');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'bathaoapp@gmail.com');
    if (!await launchUrl(emailUri)) {
      throw 'Could not launch $emailUri';
    }
  }
}
