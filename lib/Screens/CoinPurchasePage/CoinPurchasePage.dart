import 'dart:async';
import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinPurchasePage extends StatelessWidget {
  CoinPurchasePage({super.key});
  final PaymentController controller = Get.put(PaymentController());

  final List<Map<String, dynamic>> packages = [
    {"coins": 100, "price": 1},
    {"coins": 500, "price": 3, "bonus": 50},
    {"coins": 1000, "price": 6, "bonus": 200},
  ];

  final List<Map<String, dynamic>> purchaseHistory = [
    {"coins": 100, "date": "2025-06-20", "amount": "₹1"},
    {"coins": 500, "date": "2025-06-18", "amount": "₹3"},
    {"coins": 1000, "date": "2025-06-12", "amount": "₹6"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text("Buy Coins", style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Coin Packages",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  controller.coinPlan.map((pkg) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.onBoardSecondary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.borderColor,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (pkg.description!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(bottom: 6),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  pkg.description!,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Icon(
                              Icons.monetization_on,
                              color: Colors.amberAccent,
                              size: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${pkg.coins} Coins",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\₹${pkg.rate}",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final int amountInPaise = pkg.rate!;
                                final phone = userModel!.user!.phone;
                                showPaymentDetailsDialog(
                                  amount: amountInPaise.toInt(),
                                  customerPhone: phone!,
                                  onConfirmed: (upiId, email) async {
                                    await controller.initiateUPIPayment(
                                      customerName: userModel!.user!.name!,
                                      amountInPaise: amountInPaise,
                                      upiId: upiId,
                                      customerPhone: phone,
                                      customerEmail: email,
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.onBoardPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Buy",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            // Obx(() {
            //   final orderId = controller.currentOrderId.value;
            //   final expiry = controller.paymentExpiry.value;
            //
            //   if (orderId.isNotEmpty && expiry != null) {
            //     final remaining = expiry.difference(DateTime.now());
            //     if (remaining.isNegative) {
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //         controller.currentOrderId.value = '';
            //         controller.paymentExpiry.value = null;
            //         Get.offAll(() => CoinPurchasePage());
            //         Get.snackbar("Timeout", "Payment time expired.");
            //       });
            //       return SizedBox.shrink();
            //     }
            //
            //     return Column(
            //       children: [
            //         Text(
            //           "Payment valid for: ${remaining.inSeconds}s",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         const SizedBox(height: 10),
            //        ElevatedButton.icon(
            //           onPressed: () async {
            //             final isVerified = await controller
            //                 .verifyPaymentStatus(orderId);
            //             print(isVerified);
            //             if (isVerified) {
            //               await controller.addCoinPurchase(orderId);
            //               controller.currentOrderId.value = '';
            //               controller.paymentExpiry.value = null;
            //               Get.offAll(() => CoinPurchasePage());
            //               Get.snackbar(
            //                   "Success", "Coins successfully added 🎉");
            //             }
            //           },
            //           icon: Icon(Icons.verified, color: Colors.white),
            //           label: Text("Payment Done? Check Status",
            //               style: TextStyle(color: Colors.white)),
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.green,
            //             padding: EdgeInsets.symmetric(
            //                 vertical: 12, horizontal: 20),
            //           ),
            //         ),
            //         SizedBox(height: 20),
            //       ],
            //     );
            //   }
            //
            //   return SizedBox.shrink();
            // }),
            Text(
              "Purchase History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: purchaseHistory.length,
                itemBuilder: (context, index) {
                  final item = purchaseHistory[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${item['coins']} Coins",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item['amount'],
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item['date'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentDetailsDialog({
    required int amount,
    required String customerPhone,
    required Function(String upiId, String email) onConfirmed,
  }) {
    final upiController = TextEditingController();
    final emailController = TextEditingController();
    final isLoading = false.obs;
    final isPaymentStarted = false.obs;
    final RxInt remainingSeconds = 60.obs;
    Timer? countdownTimer;

    void startCountdown() {
      countdownTimer?.cancel();
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          timer.cancel();
          Get.back(); // Auto-close the dialog
          Get.snackbar("Timeout", "Payment dialog expired");
        }
      });
    }

    Get.dialog(
      Obx(
        () => AlertDialog(
          backgroundColor: Colors.black,
          title: Text("Payment Details", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: upiController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "UPI ID",
                  hintText: "e.g., user@upi",
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "your@email.com",
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              if (isPaymentStarted.value) ...[
                const SizedBox(height: 16),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                            onPressed: () async {
                              final orderId = controller.currentOrderId.value;
                              if (orderId.isNotEmpty) {
                                final verified = await controller
                                    .verifyPaymentStatus(orderId);
                                if (verified) {
                                  await controller.addCoinPurchase(orderId);
                                  controller.currentOrderId.value = '';
                                  controller.paymentExpiry.value = null;
                                  Get.back(); // Close dialog
                                  Get.snackbar(
                                    "Success",
                                    "Coins added 🎉",
                                    backgroundColor: AppColors.textColor,
                                  );
                                } else {
                                  Get.snackbar(
                                    "Pending",
                                    "Payment not yet completed.",
                                    backgroundColor: AppColors.textColor,
                                  );
                                }
                              }
                            },
                            icon: Icon(Icons.verified, color: Colors.white),
                            label: Text(
                              "Payment Done?",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                ),
              ],
            ],
          ),
          actions: [
            if (!isPaymentStarted.value)
              TextButton(
                onPressed: () {
                  countdownTimer?.cancel();
                  Get.back();
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
            ElevatedButton(
              onPressed:
                  isLoading.value
                      ? null
                      : () async {
                        final upiId = upiController.text.trim();
                        final email = emailController.text.trim();

                        if (upiId.isEmpty || !upiId.contains("@")) {
                          Get.snackbar(
                            "Invalid",
                            "Enter a valid UPI ID",
                            backgroundColor: AppColors.textColor,
                          );
                          return;
                        }
                        if (email.isEmpty || !email.contains("@")) {
                          Get.snackbar(
                            "Invalid",
                            "Enter a valid email address",
                            backgroundColor: AppColors.textColor,
                          );
                          return;
                        }

                        isLoading.value = true;

                        await onConfirmed(upiId, email);
                        isLoading.value = false;
                        isPaymentStarted.value = true;
                        remainingSeconds.value = 60;
                        startCountdown();
                      },
              child:
                  isLoading.value
                      ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text("Proceed & Pay"),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
