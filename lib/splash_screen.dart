import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7FAFF),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// شعار التطبيق
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/images/photo_2025-04-16_14-38-02-removebg-preview.png", // عدل المسار حسب مشروعك
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 10),

                /// اسم التطبيق
                const Text(
                  "SmartCare",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A73E8),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "نظام إدارة المرضى والأطباء",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 40),

                /// مؤشّر تحميل
                const CircularProgressIndicator(strokeWidth: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
