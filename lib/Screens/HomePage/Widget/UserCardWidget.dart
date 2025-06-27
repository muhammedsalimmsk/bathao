import 'dart:math';
import 'package:bathao/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class UserCard extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String? imageUrl;
  final int coins;
  final int stars;
  final String status;
  final String userId;

  const UserCard({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.imageUrl,
    required this.coins,
    required this.stars,
    required this.status,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {

   
    CallController callController=Get.put(CallController());
    Color getRandomColor() {
      final Random random = Random();
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    Color getStatusColor() {
      switch (status.toLowerCase()) {
        case "online":
          return Colors.green;
        case "offline":
          return Colors.red;
        case "busy":
          return Colors.yellow;
        default:
          return Colors.grey;
      }
    }

    final Color statusColor = getStatusColor();
    print("userId is $userId");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: (imageUrl == null) ? getRandomColor() : null,
                    backgroundImage:
                        (imageUrl != null) ? NetworkImage("$baseImageUrl$imageUrl") : null,
                    child:
                        (imageUrl == null)
                            ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : null,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        gender == "male" ? Icons.person : Icons.face_4,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$age age",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.orange),
                    Text(
                      " ${coins.toString().padLeft(2, '0')}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Container(height: 20, width: 1, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.orangeAccent),
                    Text(" $stars", style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    ZegoSendCallInvitationButton(
                      buttonSize: const Size(40, 40),
                      isVideoCall: false,
                      resourceID: "zegouikit_call",
                      invitees: [
                        ZegoUIKitUser(
                          id: userId,
                          name: name,
                        ),
                      ],
                    ),
                    ZegoSendCallInvitationButton(
                      buttonSize: const Size(40, 40),
                      isVideoCall: true,
                      resourceID: "zegouikit_call",
                      invitees: [
                        ZegoUIKitUser(
                          id: userId,
                          name: name,
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}
