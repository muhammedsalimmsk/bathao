import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:bathao/Screens/CoinPurchasePage/PurchaseHistoryPage.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/plan_model/plan.dart';

class CoinPurchasePage extends StatelessWidget {
  CoinPurchasePage({super.key});
  final PaymentController controller = Get.put(PaymentController());

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textColor),
        title: Text("Wallet", style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.onBoardSecondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppColors.borderColor, blurRadius: 6),
                ],
              ),
              child: Center(
                child: Obx(
                  () => Text(
                    "Available Coins: ${totalCoin.value ?? 0}",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Coin Packages",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final plans = controller.coinPlan;
              return GridView.builder(
                itemCount: plans.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return _buildCoinPlanCard(plans[index]);
                },
              );
            }),

            Spacer(flex: 1),
            Center(
              child: GestureDetector(
                onTap: () {
                  Get.to(PurchaseHistoryPage());
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.onBoardPrimary,
                  ),
                  child: Center(
                    child: Text(
                      "Purchase History",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinPlanCard(Plan pkg) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () async {
        String package = pkg.id!;
        if (userModel!.user!.email == null) {
          Get.dialog(
            AlertDialog(
              backgroundColor: AppColors.onBoardSecondary,
              title: const Text('Enter your Email'),
              content: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@mail.com',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    if (email.isNotEmpty && GetUtils.isEmail(email)) {
                      Get.back();
                      await controller.createPayment(package, email);
                    } else {
                      Get.snackbar(
                        'Invalid Email',
                        'Please enter a valid email address',
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onBoardPrimary,
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          await controller.createPayment(package, null);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.onBoardSecondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.borderColor, blurRadius: 6)],
        ),
        child: Column(
          children: [
            if (pkg.description != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            Text('🪙', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text("${pkg.coins} Coins", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              "\₹${pkg.rate}",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
