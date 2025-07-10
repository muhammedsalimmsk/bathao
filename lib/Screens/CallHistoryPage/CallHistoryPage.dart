import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/CallHistoryController/CallHiistoryController.dart';
import '../../Theme/Colors.dart';

class CallHistoryPage extends StatelessWidget {
  final CallHistoryController controller = Get.put(CallHistoryController());
  final ScrollController scrollController = ScrollController();

  CallHistoryPage({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.getHistory(); // Fetch next page
      }
    });
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  String formatCallDate(DateTime callDate) {
    final now = DateTime.now();
    final difference = now.difference(callDate).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference <= 7) {
      return "$difference days ago";
    } else {
      return "${callDate.day.toString().padLeft(2, '0')}/"
          "${callDate.month.toString().padLeft(2, '0')}/"
          "${callDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Call History",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: scrollController,
                    itemCount: controller.historyData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.historyData.length) {
                        return controller.hasMore.value
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox(); // No more items
                      }

                      final history = controller.historyData[index];
                      final name = history.receiver?.displayName ?? 'Unknown';
                      final type = history.callType ?? 'N/A';
                      final time = history.minutesCharged ?? '';
                      final String dateStr = history.createdAt.toString();
                      final callDateUtc =
                          DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
                      final callDate = callDateUtc.toLocal();
                      final formattedDate = formatCallDate(callDate);
                      final formattedTime = TimeOfDay.fromDateTime(
                        callDate,
                      ).format(context);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: ListTile(
                          title: Text(
                            name,
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          subtitle: Text(
                            "$type • $time mins",
                            style: TextStyle(color: AppColors.borderColor),
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: getRandomColor(),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: AppColors.borderColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
