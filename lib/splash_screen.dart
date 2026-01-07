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
                /// هون الشعار 
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/images/14c26c09-c455-4327-87db-e93d0b497601.png", 
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

              

               

                const SizedBox(height: 6),

                const Text(
                  "نظام إدارة المرضى والأطباء",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 40),

                const CircularProgressIndicator(strokeWidth: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
