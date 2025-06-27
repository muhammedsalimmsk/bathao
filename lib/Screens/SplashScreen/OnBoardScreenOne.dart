import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';

class OnBoardPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isFirst;
  final int currentPage;
  final VoidCallback onTap;

  const OnBoardPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.currentPage,
    this.isFirst = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.onBoardColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 60),
              Image.asset(imagePath, height: 600),
              Spacer(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.onBoardPrimary,
                    AppColors.onBoardSecondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(isActive: currentPage == 0),
                      SizedBox(width: 6),
                      _buildIndicator(isActive: currentPage == 1),
                      SizedBox(width: 6),
                      _buildIndicator(isActive: currentPage == 2),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: AppColors.textColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),

                  // Custom Button
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getStartBackground,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Get Started",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textColor,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textColor.withOpacity(0.8),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textColor.withOpacity(0.6),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textColor.withOpacity(0.4),
                          ),
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: AppColors.buttonGradient,
                                begin: Alignment.topLeft,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.30,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return Container(
      width: isActive ? 50 : 28,
      height: isActive ? 6 : 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
