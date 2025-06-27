import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class CallInvitePage extends StatefulWidget {
  const CallInvitePage({super.key});

  @override
  State<CallInvitePage> createState() => _CallInvitePageState();
}

class _CallInvitePageState extends State<CallInvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ZegoSendCallInvitationButton(
          isVideoCall: true,
          //You need to use the resourceID that you created in the subsequent steps.
          //Please continue reading this document.
          resourceID: "zegouikit_call",
          invitees: [
            ZegoUIKitUser(
              id: "salim123",
              name: 'salim',
            ),
          ],
        )
      ),
    );
  }
}
