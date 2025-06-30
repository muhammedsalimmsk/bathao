import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:get/get.dart';
class MyCustomCallButton extends StatelessWidget {
  final String userId;
  final String name;
  final bool isVideoCall;

   MyCustomCallButton({
    super.key,
    required this.userId,
    required this.name,
    this.isVideoCall = false,
  });
   PaymentController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(controller.totalCoin.value);

        if (controller.totalCoin.value >= 100) {
          if (isVideoCall) {
            if (controller.totalCoin.value >= 200) {
              ZegoUIKitPrebuiltCallInvitationService().send(
                isVideoCall: true,
                invitees: [ZegoCallUser(userId, name)],
                resourceID: "zegouikit_call",
              );
            } else {
              Get.snackbar(
                "Insufficient balance",
                "You need at least 200 coins for a video call",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.textColor,
              );
            }
          } else {
            // Audio call, needs at least 100 coins
            ZegoUIKitPrebuiltCallInvitationService().send(
              isVideoCall: false,
              invitees: [ZegoCallUser(userId, name)],
              resourceID: "zegouikit_call",
            );
          }
        } else {
          Get.snackbar(
            "Insufficient balance",
            "Please recharge your coin balance",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.textColor,
          );
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.onBoardPrimary, // 🔵 Blue background
          shape: BoxShape.circle, // 🎯 Round button
        ),
        child: Icon(
          isVideoCall?Icons.videocam_rounded:Icons.call, // 📞 You can use Icons.videocam for video
          color: Colors.white, // ⚪ White icon
          size: 30,
        ),
      ),
    );
  }
}
