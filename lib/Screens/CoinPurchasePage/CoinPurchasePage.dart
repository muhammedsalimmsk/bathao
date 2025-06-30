import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinPurchasePage extends StatelessWidget {
  CoinPurchasePage({super.key});
  final PaymentController controller = Get.put(PaymentController());

  final List<Map<String, dynamic>> packages = [
    {"coins": 100, "price": "₹0.99"},
    {"coins": 500, "price": "₹3.99", "bonus": 50},
    {"coins": 1000, "price": "₹6.99", "bonus": 200},
  ];

  final List<Map<String, dynamic>> purchaseHistory = [
    {"coins": 100, "date": "2025-06-20", "amount": "₹0.99"},
    {"coins": 500, "date": "2025-06-18", "amount": "₹3.99"},
    {"coins": 1000, "date": "2025-06-12", "amount": "₹6.99"},
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
            Text("Coin Packages",
                style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: packages.map((pkg) {
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
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        if (pkg.containsKey("bonus"))
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "+${pkg['bonus']} Bonus",
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Icon(Icons.monetization_on,
                            color: Colors.amberAccent, size: 36),
                        const SizedBox(height: 8),
                        Text("${pkg['coins']} Coins",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(pkg['price'],
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            int _parsePriceToPaise(String price) {
                              final cleaned =
                              price.replaceAll(RegExp(r'[^\d.]'), '');
                              final doubleAmount =
                                  double.tryParse(cleaned) ?? 0.0;
                              return (doubleAmount * 100).toInt();
                            }

                            final amountInPaise =
                            _parsePriceToPaise(pkg['price']);
                            final phone = userModel!.user!.phone;

                            showUPIEntryDialog(
                              amount: amountInPaise,
                              customerPhone: phone!,
                              onConfirmed: (upiId) async {
                                await controller.initiateUPIPayment(
                                  customerName: userModel!.user!.name!,
                                  amountInPaise: amountInPaise,
                                  upiId: upiId,
                                  customerPhone: phone,
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Buy",
                              style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Obx(() {
              final orderId = controller.currentOrderId.value;
              return orderId.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.verifyPaymentStatus(orderId);
                  },
                  icon: Icon(Icons.verified, color: Colors.white),
                  label: Text("Payment Done? Check Status",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                  ),
                ),
              )
                  : SizedBox.shrink();
            }),
            const SizedBox(height: 12),
            Text("Purchase History",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
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
                            Icon(Icons.monetization_on,
                                color: Colors.amber, size: 24),
                            const SizedBox(width: 10),
                            Text("${item['coins']} Coins",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(item['amount'],
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold)),
                            Text(item['date'],
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        )
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

  void showUPIEntryDialog({
    required int amount,
    required String customerPhone,
    required Function(String upiId) onConfirmed,
  }) {
    final upiController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black,
        title: Text("Enter UPI ID", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: upiController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g., user@upi",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final upiId = upiController.text.trim();
              if (upiId.isNotEmpty && upiId.contains("@")) {
                Get.back();
                onConfirmed(upiId);
              } else {
                Get.snackbar("Invalid", "Please enter a valid UPI ID");
              }
            },
            child: Text("Proceed"),
          ),
        ],
      ),
    );
  }
}
