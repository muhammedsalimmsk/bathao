import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../Models/listners_model/listners_model.dart';
import '../../Models/listners_model/receiver.dart';
import '../../Screens/AuthPage/LoginPage.dart';
import '../../Services/ApiService.dart';
// Update path if needed

class ListenerController extends GetxController {
  List<Receiver> listenerData = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1; // Start from page 0
  final int limit = 10;
  List langs = [];

  final ApiService _apiService = ApiService();

  String searchQuery = '';
  String sortOrder = '';

  late ListenersModel dataModel = ListenersModel();

  @override
  void onInit() async {
    super.onInit();
    await fetchListeners();
  }

  Future<void> fetchListeners() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    update(); // Rebuild the UI

    try {
      final response = await _apiService.getRequest(
        'api/v1/user/get-receivers?page=$currentPage&limit=$limit'
        '&sortOrder=$sortOrder&search=$searchQuery'
        '&langs=${langs.join(',')}',
        bearerToken: jwsToken,
      );

      if (response.isOk) {
        print(response.body);
        final data = ListenersModel.fromJson(response.body);
        print(data);

        final newListeners = data.receivers ?? [];
        listenerData.addAll(newListeners);
        if (newListeners.length < limit) {
          hasMore = false;
        } else {
          currentPage++;
        }
        print("Fetched Listeners: ${listenerData.length}");
      } else {
        hasMore = false;
        // if (response.body['error'] == 'jwt expired' ||
        //     response.body['error'] == 'invalid token') {
        //   SharedPreferences pref = await SharedPreferences.getInstance();
        //   pref.clear();
        //   Get.offAll(() => LoginPage());
        // }
        print("Error response: ${response.body}");
      }
    } catch (e) {
      print("Fetch error: $e");
      hasMore = false;
    }

    isLoading = false;
    update(); // Refresh UI
  }

  Future<void> refreshListeners() async {
    listenerData.clear();
    currentPage = 0;
    hasMore = true;
    await fetchListeners();
  }

  Future<void> applySorting(String type) async {
    switch (type) {
      case "Oldest":
        sortOrder = "oldest";
        break;
      default:
        sortOrder = '';
    }
    await refreshListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    refreshListeners();
  }
}
