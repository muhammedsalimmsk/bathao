import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:bathao/Screens/HomePage/Widget/CustomAppBar.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Services/CallApis/CallApis.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:get/get.dart';
import '../../Services/CallTracker.dart';
import 'Widget/LanguegeChipsWidget.dart';
import 'Widget/ListenerListWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final PaymentController controller = Get.put(PaymentController());
  final CallController callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    bool _hasShownUnavailableDialog = false;
    final callTracker = CallTracker();
    ZegoUIKitPrebuiltCallInvitationService().init(
      appSign: CallApis.appSign,
      appID: CallApis.appId,
      userID: userModel!.user!.id!,
      userName: userModel!.user!.name!,
      plugins: [ZegoUIKitSignalingPlugin()],
      events: ZegoUIKitPrebuiltCallEvents(
        room: ZegoCallRoomEvents(
          onStateChanged: callTracker.onRoomStateChanged,
        ),
        onCallEnd: callTracker.onCallEnd,
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (String callID, ZegoCallUser callee) {
          debugPrint("📲 Callee accepted invite. callID: $callID");
        },
        onError: (ZegoUIKitError error) {
          debugPrint("❌ ZEGOCLOUD Error: ${error.code} - ${error.message}");

          // 107026 = all called users not registered
          if (error.code == 107026 && !_hasShownUnavailableDialog) {
            _hasShownUnavailableDialog = true;
            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: AppColors.onBoardSecondary,
              title: "Error",
              middleText: "Please call after some time",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                _hasShownUnavailableDialog = false;
                Get.back();
              },
            );
          } else if (_hasShownUnavailableDialog == false) {
            _hasShownUnavailableDialog = true;
            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: AppColors.onBoardSecondary,
              title: "Error",
              middleText: "Please call after some time",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                _hasShownUnavailableDialog = false;
                Get.back();
              },
            );
          }
        },

        // add more invitation events as needed
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomHomeAppBar(
        userName: userModel!.user!.name!,
        coinCount: controller.totalCoin,
        profileImageUrl:
            userModel!.user!.profilePic == null
                ? "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=2671&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                : "$baseImageUrl${userModel!.user!.profilePic!}",
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
            SizedBox(height: 520, child: ListenerListWidget()),
          ],
        ),
      ),
    );
  }
}
