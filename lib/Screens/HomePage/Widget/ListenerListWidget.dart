import 'package:bathao/Controllers/ListenerController/ListenerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UserCardWidget.dart';

class ListenerListWidget extends StatelessWidget {
  const ListenerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String getAgeOrNA(DateTime? birthDate) {
      if (birthDate == null) return 'N/A';

      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    }

    ListenerController controller = Get.put(ListenerController());
    return GetBuilder<ListenerController>(
      builder: (controller) {
        if (controller.isLoading && controller.listenerData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.refreshListeners();
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.listenerData.length,
            itemBuilder: (context, index) {
              return UserCard(
                name: controller.listenerData[index].displayName!,
                age: getAgeOrNA(controller.listenerData[index].dateOfBirth),
                gender: controller.listenerData[index].gender!,
                imageUrl: controller.listenerData[index].profilePic,
                audioRate: controller.listenerData[index].audioRate!,
                videoRate: controller.listenerData[index].videoRate!,
                callType: controller.listenerData[index].callType!,
                coins: 3,
                status: controller.listenerData[index].status!,
                userId: controller.listenerData[index].id!,
              );
            },
          ),
        );
      },
    );
  }
}
