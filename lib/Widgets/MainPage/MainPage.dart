// pages/main_page.dart
import 'package:bathao/Screens/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/BottomNavController/BottomNavController.dart';

class MainPage extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    HomePage(),
    Center(child: Text('Search Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
