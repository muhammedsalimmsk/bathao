import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Models/call_history_model/history.dart';
import 'package:get/get.dart';
import '../../Models/call_history_model/call_history_model.dart';
import '../../Services/ApiService.dart';

class CallHistoryController extends GetxController {
  CallHistoryModel callHistoryModel = CallHistoryModel();
  RxList<History> historyData = <History>[].obs;
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int currentPage = 1;
  final int limit = 10;

  Future<void> getHistory() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    final endpoint =
        'api/v1/call/user-call-history?page=$currentPage&limit=$limit';

    try {
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        final CallHistoryModel fetched = CallHistoryModel.fromJson(
          response.body,
        );
        final newItems = fetched.history ?? [];

        if (newItems.length < limit) {
          hasMore.value = false;
        }

        historyData.addAll(newItems);
        currentPage++;
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getHistory();
  }
}
