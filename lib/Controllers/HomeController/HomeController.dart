import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var showSearchInAppBar = false.obs;

  void _scrollListener() {
    if (scrollController.offset > 100 && !showSearchInAppBar.value) {
      showSearchInAppBar.value = true;
    } else if (scrollController.offset <= 100 && showSearchInAppBar.value) {
      showSearchInAppBar.value = false;
    }
  }

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    super.onInit();
  }
}
