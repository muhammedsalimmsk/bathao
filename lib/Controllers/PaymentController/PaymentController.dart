// controllers/payment_controller.dart
import 'dart:convert';
import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  final isLoading = false.obs;
  RxString currentOrderId = ''.obs;
  RxInt totalCoin=0.obs;
  final ApiService _apiService=ApiService();
  static const String merchantId = "eP7quf";
  static const String apiKey = "utz_live_574c29d7d345de5d";
  static const String publicKey='utz_live_574c29d7d345de5d';
  static const String secretKey='9f420ed0b8ac95417b76qbx';

  String get _basicAuthHeader {
    String credentials = '$publicKey:$secretKey';
    String base64Str = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Str';
  }
  Future<void> initiateUPIPayment({
    required int amountInPaise,
    required String upiId,
    required String customerPhone,
    required String customerName
  }) async {
    const String createApiUrl = "https://api.upitranzact.com/v1/payments/createPaymentRequest";


    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(createApiUrl),
        headers: {'Content-Type': 'application/json',
        'Authorization':_basicAuthHeader},
        body: jsonEncode({
          "mid": merchantId,
          "vpa": upiId,
          'note':"coin credit",
          "amount": amountInPaise,
          'customer_name':customerName,// paise: ₹1.00 = 100
          "customer_phone": customerPhone,
          "api_key": apiKey, // optional
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        final paymentUrl = data['payment_url'];
        await launchUrl(Uri.parse(paymentUrl), mode: LaunchMode.externalApplication);
      } else {
        print(response.body);
        Get.snackbar("Payment Failed", data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString(),backgroundColor: AppColors.textColor);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyPaymentStatus(String orderId) async {
    const String statusUrl = "https://www.upitranzact.com/api/status";
    const String merchantId = "YOUR_MERCHANT_ID";
    const String apiKey = "YOUR_API_KEY";

    try {
      final response = await http.post(
        Uri.parse(statusUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "merchant_id": merchantId,
          "order_id": orderId,
          "api_key": apiKey,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        final transactionStatus = data['transaction_status'];
        if (transactionStatus == "Completed") {
          currentOrderId.value = '';
          Get.snackbar("Success", "Coins added to your account 🎉");
          // TODO: Add coin update logic here
        } else {
          Get.snackbar("Not Completed", "Transaction not yet completed.");
        }
      } else {
        Get.snackbar("Error", data['message'] ?? "Verification failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
  Future getCoin()async{
    final endpoint='api/v1/coin/get-user-coin-balance';
    try{
      final response=await _apiService.getRequest(endpoint,bearerToken: jwsToken);
      if(response.isOk){
        print(response.body);
        totalCoin.value=response.body['coins'];
      }else{
        print(response.body);
      }
    }catch(e){
      print(e);
      rethrow;
    }
  }
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    getCoin();
  }

}
