import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsCheckbox extends StatelessWidget {
  final RxBool isChecked;
  final VoidCallback onTapTerms;

  const TermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onTapTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => Checkbox(
            value: isChecked.value,
            onChanged: (val) => isChecked.value = val ?? false,
            activeColor: Colors.pinkAccent,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Agree with ",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "Terms & Condition",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTapTerms,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
