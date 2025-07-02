// controllers/payment_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Models/plan_model/plan.dart';
import 'package:bathao/Models/plan_model/plan_model.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Screens/CoinPurchasePage/CoinPurchasePage.dart';

class PaymentController extends GetxController {
  final isLoading = false.obs;
  RxString currentOrderId = ''.obs;
  RxInt totalCoin = 0.obs;
  PlanModel model=PlanModel();
  RxList<Plan> coinPlan=<Plan>[].obs;
  final ApiService _apiService = ApiService();
  Rx<DateTime?> paymentExpiry = Rx<DateTime?>(null);
  Timer? paymentTimer;
  static const String merchantId = "WATZOP";
  static const String apiKey = "utz_live_2ca3df4accd797bb";
  static const String publicKey = 'utz_live_2ca3df4accd797bb';
  static const String secretKey = '44d37239655faa322ceejlo';

  String get _basicAuthHeader {
    String credentials = '$publicKey:$secretKey';
    String base64Str = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Str';
  }

  Future<void> initiateUPIPayment({
    required int amountInPaise,
    required String upiId,
    required String customerPhone,
    required String customerName,
    required String customerEmail,
  }) async {
    const String createApiUrl =
        "https://api.upitranzact.com/v1/payments/createPaymentRequest";

    isLoading.value = true;

    try {
      final cleanedPhone = customerPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final tenDigitPhone =
          cleanedPhone.length >= 10
              ? cleanedPhone.substring(cleanedPhone.length - 10)
              : cleanedPhone;

      print('Original phone: $customerPhone');
      print('Cleaned phone: $tenDigitPhone');
      final response = await http.post(
        Uri.parse(createApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _basicAuthHeader,
        },
        body: jsonEncode({
          "mid": merchantId,
          "vpa": upiId,
          'note': "coin credit",
          "amount": amountInPaise.toInt(),
          'customer_name': customerName, // paise: ₹1.00 = 100
          "customer_mobile": tenDigitPhone,
          'customer_email': customerEmail,
          "api_key": apiKey, // optional
        }),
      );
      print(tenDigitPhone);
      print(_basicAuthHeader);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        final orderId = data['data']['order_id'];
        final expiryTime = DateTime.parse(data['data']['expiry']);

        currentOrderId.value = orderId;
        print("oderid is ${currentOrderId.value}");
        paymentExpiry.value = expiryTime;
      } else {
        print(response.body);
        Get.snackbar(
          "Payment Failed",
          data['message'] ?? 'Something went wrong',
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString(), backgroundColor: AppColors.textColor);
    } finally {
      isLoading.value = false;
    }
  }

  Future getCoin() async {
    final endpoint = 'api/v1/coin/get-user-coin-balance';
    try {
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        totalCoin.value = response.body['coins'];
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> verifyPaymentStatus(String orderId) async {
    const String statusUrl =
        "https://api.upitranzact.com/v1/payments/checkPaymentStatus";
    isLoading.value = true;
    try {
      print("verify order iid is $orderId");
      print(merchantId);
      final response = await http.post(
        Uri.parse(statusUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _basicAuthHeader,
        },
        body: jsonEncode({"mid": merchantId, "order_id": orderId}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        await addCoinPurchase(orderId);
        final transactionStatus = data['data']['status'];
        return transactionStatus == "SUCCESS";
      } else {
        Get.snackbar("Error", data['message'] ?? "Verification failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> addCoinPurchase(String orderId) async {
    final endpoint = 'api/v1/coin/credit'; // change this to your actual API
    try {
      final response = await _apiService.postRequest(endpoint, {
        "order_id": orderId,
      }, bearerToken: jwsToken);

      if (response.isOk) {
        Get.snackbar("Success", "Coins added to your account 🎉");
        await getCoin(); // Refresh coin balance
      } else {
        Get.snackbar("Error", "Failed to add coins");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  Future getPlan() async {
    final endpoint = 'api/v1/user/get-all-plans';
    try {
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        model=PlanModel.fromJson(response.body);
        coinPlan.addAll(model.plans!);
      }else{
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
   await getCoin();
    await  getPlan();
  }

  @override
  void onClose() {
    paymentTimer?.cancel();
    super.onClose();
  }
}
