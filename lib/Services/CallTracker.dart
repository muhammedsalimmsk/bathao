import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallTracker {
  Timer? _minuteTimer;

  void onRoomStateChanged(ZegoUIKitRoomState state) {
    debugPrint('📡 Room state changed: ${state.reason}');

    if (state.reason == ZegoRoomStateChangedReason.Logined) {
      debugPrint('✅ Entered call room — call started.');

      _minuteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        debugPrint('⏱ Minute ${timer.tick} of the call');
        // TODO: Your per-minute action here (e.g. deduct coins, update UI)
      });
    }

    if (state.reason == ZegoRoomStateChangedReason.Logout ||
        state.reason == ZegoRoomStateChangedReason.KickOut) {
      debugPrint('❌ Left call room — call ended.');
      _minuteTimer?.cancel();
      _minuteTimer = null;
    }
  }
  void onCallEnd(ZegoCallEndEvent event, void Function() defaultAction) {
    debugPrint("❌ Call ended — reason: ${event.reason.name}");

    _minuteTimer?.cancel();
    _minuteTimer = null;

    defaultAction(); // Close call screen as normal
  }
}
