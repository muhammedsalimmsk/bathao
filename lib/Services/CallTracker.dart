import 'dart:async';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:flutter/cupertino.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:get/get.dart';

import '../main.dart';

class CallTracker {
  Timer? _minuteTimer;
  Timer? _preCutoffTimer;
  final CallController controller = Get.find();
  final PaymentController paymentController = Get.find();

  void onRoomStateChanged(ZegoUIKitRoomState state) async {
    debugPrint('📡 Room state changed: ${state.reason}');

    if (state.reason == ZegoRoomStateChangedReason.Logined) {
      debugPrint('✅ Call started');
      await controller.startCall(receiverId!, controller.callType);
      // Start the per-minute coin check
      _minuteTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        debugPrint('⏱ Minute ${timer.tick}');

        int? balance = await controller.checkBalance(
          controller.callId!,
        ); // 👈 Reduce 100 and get balance
        debugPrint('💰 Current coin balance: $balance');

        if (balance! < 100) {
          debugPrint("⚠️ Low balance. Ending call in 59 seconds.");

          _preCutoffTimer?.cancel();
          _preCutoffTimer = Timer(const Duration(seconds: 59), () {
            debugPrint("⛔ Call auto-ended due to insufficient balance.");
            controller.endCall(controller.callId!);
            _clearTimers();
            ZegoUIKitPrebuiltCallController().hangUp(
              Get.context!,
              showConfirmation: false,
            ); // Use context if needed
          });
        }
      });
    }

    if (state.reason == ZegoRoomStateChangedReason.Logout ||
        state.reason == ZegoRoomStateChangedReason.KickOut) {
      _clearTimers();
      debugPrint('❌ Call ended');
    }
  }

  void onCallEnd(ZegoCallEndEvent event, void Function() defaultAction) async {
    debugPrint("❌ Call ended — reason: ${event.reason.name}");
    _clearTimers();
    defaultAction();
    await controller.endCall(controller.callId!);
    await paymentController.getCoin();
  }

  void _clearTimers() {
    _minuteTimer?.cancel();
    _minuteTimer = null;
    _preCutoffTimer?.cancel();
    _preCutoffTimer = null;
  }
}
