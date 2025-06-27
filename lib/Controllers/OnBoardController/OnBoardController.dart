import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardController extends GetxController {
  var currentPage = 0.obs;

  void setCurrentPage(int index) {
    currentPage.value = index;
  }
}
