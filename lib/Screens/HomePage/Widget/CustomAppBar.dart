import 'package:flutter/material.dart';

import 'ProfileConnectPainter.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final int coinCount;
  final String profileImageUrl;

  const CustomHomeAppBar({
    super.key,
    required this.userName,
    required this.coinCount,
    required this.profileImageUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(180);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000D64), Color(0xFF081DAA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // 🔵 Background custom shape
              Positioned(
                left: 0,
                top: 20,
                bottom: 20,
                child: CustomPaint(
                  size: const Size(70, 120),
                  painter: ProfileConnectorPainter(),
                ),
              ),

              // 👤 Main content
              Row(
                children: [
                  // 👤 Profile image
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  const SizedBox(width: 16),
                  // 👋 Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello, $userName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "wellcome Bathao",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // 🪙 Coins
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Available Coins",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.stars, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "$coinCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
