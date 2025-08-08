import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:bathao/Controllers/HomeController/HomeController.dart';
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
import '../../Controllers/ListenerController/ListenerController.dart';
import '../../Models/listners_model/receiver.dart';
import '../../Services/CallTracker.dart';
import 'Widget/LanguegeChipsWidget.dart';
import 'Widget/ListenerListWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final PaymentController controller = Get.put(PaymentController());
  final CallController callController = Get.put(
    CallController(),
    permanent: true,
  );
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    bool hasShownUnavailableDialog = false;
    final callTracker = CallTracker();

    // Your ZegoCloud initialization
    ZegoUIKitPrebuiltCallInvitationService().init(
      appSign: CallApis.appSign,
      appID: CallApis.appId,
      userID: userModel!.user!.id!, // Ensure userModel is not null here
      userName: userModel!.user!.name!,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config =
            data.invitees.length > 1
                ? (data.type == ZegoCallInvitationType.videoCall
                    ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.groupVoiceCall())
                : (data.type == ZegoCallInvitationType.videoCall
                    ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());

        // earpiece
        config.avatarBuilder = (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map extraInfo,
        ) {
          if (user == null) {
            return const SizedBox();
          }
          final ListenerController listenerController =
              Get.find<ListenerController>();

          // 2. Search for the receiver in your list using the user.id
          String? avatarURL;
          String displayLetter = user.name.isNotEmpty ? user.name[0] : '?';

          try {
            final Receiver matchedReceiver = listenerController.listenerData
                .firstWhere((receiver) => receiver.id == user.id);
            // If a match is found, use its avatar URL
            if (matchedReceiver.profilePic != null) {
              avatarURL = "$baseImageUrl${matchedReceiver.profilePic}";
            }
          } catch (e) {
            print('Avatar not found for user ${user.id}, using default.');
          }
          return avatarURL != null
              ? Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(avatarURL),
                    fit: BoxFit.cover,
                  ),
                ),
              )
              : Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                alignment: Alignment.center,
                child: Text(
                  displayLetter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.5,
                    decoration: TextDecoration.none,
                  ),
                ),
              );
        };
        return config;
      },

      events: ZegoUIKitPrebuiltCallEvents(
        room: ZegoCallRoomEvents(
          onStateChanged: callTracker.onRoomStateChanged,
        ),
        onCallEnd: callTracker.onCallEnd,
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (String callID, ZegoCallUser callee) async {
          debugPrint(
            "📲 Callee accepted invite. callID: $callID at ${DateTime.now()}",
          );
          // Potentially set controller.callId here if it's available and not set elsewhere
          callTracker.controller.callId =
              callID; // Assuming controller.callId is mutable
        },
        onError: (ZegoUIKitError error) {
          debugPrint(
            "❌ ZEGOCLOUD Error: ${error.code} - ${error.message} at ${DateTime.now()}",
          );

          // 107026 = all called users not registered
          if (error.code == 107026 && !hasShownUnavailableDialog) {
            hasShownUnavailableDialog = true;
            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: AppColors.onBoardSecondary,
              title: "Error",
              middleText:
                  "User is not online. Please call after some time.", // More specific message
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                hasShownUnavailableDialog = false;
                Get.back();
              },
            );
          } else if (error.code != 107026 && !hasShownUnavailableDialog) {
            // Handle other errors generally
            hasShownUnavailableDialog = true;
            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: AppColors.onBoardSecondary,
              title: "Error",
              middleText:
                  "An error occurred. Please try again later. Code: ${error.code}",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                hasShownUnavailableDialog = false;
                Get.back();
              },
            );
          }
          // If dialog is already shown, do nothing to avoid multiple dialogs
        },
        // add more invitation events as needed
      ),
    );
    controller.getCoin();
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          homeController.showSearchInAppBar.value ? 60 : 180,
        ),
        child: Obx(
          () =>
              homeController.showSearchInAppBar.value
                  ? Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF000D64), Color(0xFF081DAA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // 👤 Profile image
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                userModel!.user!.profilePic == null
                                    ? "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=2671&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                                    : "$baseImageUrl${userModel!.user!.profilePic!}",
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 👋 Greeting
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hello, ${userModel!.user!.name!}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "welcome Bathao",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            // 🪙 Coins
                          ],
                        ),
                        Positioned(
                          top: 10,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Available Coins",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.stars, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Obx(
                                    () => Text(
                                      totalCoin.value.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  : CustomHomeAppBar(
                    userName: userModel!.user!.name!,
                    coinCount: totalCoin,
                    profileImageUrl:
                        userModel!.user!.profilePic == null
                            ? "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=2671&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                            : "$baseImageUrl${userModel!.user!.profilePic!}",
                  ),
        ),
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
              languages: ['English', 'Malayalam', 'Kannada', 'Arabic', 'Tamil'],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.56,
              child: ListenerListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
