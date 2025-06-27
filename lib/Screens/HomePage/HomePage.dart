import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Screens/HomePage/Widget/CustomAppBar.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Services/CallApis/CallApis.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'Widget/LanguegeChipsWidget.dart';
import 'Widget/ListenerListWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appSign: CallApis.appSign,
        appID: CallApis.appId,
        userID: userModel!.user!.id!,
        userName: userModel!.user!.name!,
        plugins: [ZegoUIKitSignalingPlugin()]);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomHomeAppBar(
        userName: userModel!.user!.name!,
        coinCount: 120,
        profileImageUrl:
            // userModel!.user!.profilePic==null?
            "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=2671&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        // "$baseImageUrl${userModel!.user!.profilePic!}",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              "Top Specialists",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            LanguageChips(
              languages: ['English', 'Malayalam', 'Kannada', 'Arabic'],
              onTap: (lang) {
                print('Selected: $lang');
              },
            ),
            SizedBox(height: 480, child: ListenerListWidget()),
          ],
        ),
      ),
    );
  }
}
