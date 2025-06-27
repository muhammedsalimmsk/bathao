import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';

class LanguageChips extends StatelessWidget {
  final List<String> languages;
  final void Function(String)? onTap;

  const LanguageChips({Key? key, required this.languages, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            languages.map((lang) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onTap?.call(lang),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grayColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      lang,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
