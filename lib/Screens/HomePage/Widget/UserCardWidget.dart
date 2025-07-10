import 'dart:math';
import 'package:bathao/Screens/HomePage/Widget/CallButton.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String? imageUrl;
  final String callType;
  final int coins;
  final String status;
  final String userId;
  final int audioRate;
  final int videoRate;

  const UserCard({
    super.key,
    required this.name,
    required this.age,
    required this.callType,
    required this.gender,
    required this.imageUrl,
    required this.coins,
    required this.status,
    required this.userId,
    required this.audioRate,
    required this.videoRate,
  });

  @override
  Widget build(BuildContext context) {
    CallController callController = Get.put(CallController());

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
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
                    backgroundColor:
                        (imageUrl == null) ? getRandomColor() : null,
                    backgroundImage:
                        (imageUrl != null)
                            ? NetworkImage("$baseImageUrl$imageUrl")
                            : null,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.call, color: Colors.greenAccent, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "$audioRate",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.videocam,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$videoRate",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    MyCustomCallButton(
                      userId: userId,
                      name: name,
                      status: status,
                      isEnabled: callType == "audio" || callType == "both",
                    ),
                    const SizedBox(width: 10),
                    MyCustomCallButton(
                      userId: userId,
                      name: name,
                      status: status,
                      isVideoCall: true,
                      isEnabled: callType == "video" || callType == "both",
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
