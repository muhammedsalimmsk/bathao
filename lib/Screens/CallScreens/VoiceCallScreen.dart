import 'package:bathao/Screens/CallScreens/CallInvitePage.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../Services/CallApis/CallApis.dart';
class CallingPage extends StatefulWidget {
  const CallingPage({super.key});

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          ZegoUIKitPrebuiltCallInvitationService().init(
              appID: CallApis.appId,
              appSign: CallApis.appSign,
              userID: "abcd",
              userName: "salimmsk",
              plugins: [ZegoUIKitSignalingPlugin()]).then((_){
            print("zegoooososososososososososososososo");
          });

          Navigator.push(context, MaterialPageRoute(builder: (context)=>CallInvitePage()));
        }, child: Text("Call")),
      ),
    );
  }
}
