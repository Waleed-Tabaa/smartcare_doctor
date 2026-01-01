// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:bot_toast/bot_toast.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:smartcare/buttom_navigation_bar/buttom_navigation_bar.dart';

// class LoginDoctorController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isPasswordHidden = true;

//   final box = GetStorage();

//   // بيانات تسجيل دخول ثابتة (بدون API)
//   final String validEmail = "doctor@smartcare.com";
//   final String validPassword = "123456";

//   void togglePasswordVisibility() {
//     isPasswordHidden = !isPasswordHidden;
//     update();
//   }

//   void login() {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     // التحقق من الحقول
//     if (email.isEmpty || password.isEmpty) {
//       BotToast.showText(
//         text: "يرجى تعبئة جميع الحقول",
//         contentColor: Colors.red,
//       );
//       return;
//     }

//     // التحقق من صحة البريد وكلمة المرور
//     if (email != validEmail || password != validPassword) {
//       BotToast.showText(
//         text: "بيانات الدخول غير صحيحة ❌",
//         contentColor: Colors.red,
//       );
//       return;
//     }

//     // تسجيل ناجح
//     BotToast.showText(text: "تم تسجيل الدخول بنجاح 🎉");

//     // حفظ حالة الدخول
//     box.write("isLoggedIn", true);
//     box.write("doctorEmail", email);

//     // الانتقال إلى الصفحة الرئيسية
//     Get.off(() =>  HomeWithBottomNav());
//   }

//   void logout() {
//     box.erase();
//     Get.offAllNamed("/login");
//   }
// }

// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:bot_toast/bot_toast.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:smartcare/buttom_navigation_bar/buttom_navigation_bar.dart';

// // class LoginDoctorController extends GetxController {
// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   bool isPasswordHidden = true;

// //   final box = GetStorage(); // لتخزين الجلسة والبيانات

// //   // 🔵 ✅ عنوان السيرفر المُحدّث (استخدم 10.0.2.2 للمحاكي أندرويد، أو IP جهازك المحلي)
// //   //    مثال: "http://192.168.1.5:8000" إذا كان الـ backend على جهازك
// //   final String baseUrl =
// //       "http://10.0.2.2:8000"; // ⚠️ غيّر هذا حسب بيئة التشغيل!

// //   void togglePasswordVisibility() {
// //     isPasswordHidden = !isPasswordHidden;
// //     update();
// //   }

// //   // 🔵 ✅ دالة تسجيل الدخول مُعدّلة بالكامل
// //   Future<void> login() async {
// //     final email = emailController.text.trim();
// //     final password = passwordController.text.trim();

// //     // ✅ تحقق من الإدخال
// //     if (email.isEmpty || password.isEmpty) {
// //       BotToast.showText(
// //         text: "يرجى تعبئة جميع الحقول",
// //         contentColor: Colors.red,
// //       );
// //       return;
// //     }

// //     try {
// //       BotToast.showLoading();

// //       // ✅ ✅ ✅ المسار الصحيح حسب Postman: /api/doctor/login
// //       final url = Uri.parse('$baseUrl/api/doctor/login');

// //       // ✅ ✅ ✅ إرسال body كـ JSON + إضافة Content-Type
// //       final response = await http.post(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Accept': 'application/json',
// //         },
// //         body: jsonEncode({'email': email, 'password': password}),
// //       );

// //       BotToast.closeAllLoading();

// //       // ✅ معالجة الأخطاء بدقة
// //       if (response.statusCode == 401 || response.statusCode == 422) {
// //         final error = jsonDecode(response.body);
// //         final message =
// //             error['message'] ??
// //             error['error'] ??
// //             'بيانات تسجيل الدخول غير صحيحة';
// //         BotToast.showText(text: message, contentColor: Colors.red);
// //         return;
// //       }

// //       if (response.statusCode != 200) {
// //         BotToast.showText(
// //           text: 'خطأ في الخادم (${response.statusCode})',
// //           contentColor: Colors.red,
// //         );
// //         return;
// //       }

// //       // ✅ تحليل الاستجابة
// //       final data = jsonDecode(response.body);

// //       // ✅ البحث عن التوكن في الأماكن الشائعة (للمرونة)
// //       String? token = data['token'] ?? data['access_token'];
// //       if (token == null && data['data'] != null) {
// //         token = data['data']['token'] ?? data['data']['access_token'];
// //       }

// //       final user = data['user'] ?? data['data']?['user'] ?? {};

// //       // ✅ التأكد من وجود التوكن
// //       if (token == null || token.isEmpty) {
// //         BotToast.showText(
// //           text: "فشل استلام التوكن من الخادم — تحقق من API response",
// //           contentColor: Colors.red,
// //         );
// //         return;
// //       }

// //       // ✅ حفظ البيانات بأمان
// //       await box.write('token', token);
// //       await box.write('doctor', user);
// //       await box.write('isLoggedIn', true);
// //       await box.write(
// //         'userRole',
// //         'doctor',
// //       ); // ⭐️ مفيد لاحقًا في التحقق من الدور

// //       BotToast.showText(text: "تم تسجيل الدخول بنجاح 🎉");

// //       // ✅ الانتقال للواجهة الرئيسية
// //       Get.off(() => const HomeWithBottomNav());
// //     } on SocketException {
// //       BotToast.closeAllLoading();
// //       BotToast.showText(
// //         text: "لا يوجد اتصال بالإنترنت",
// //         contentColor: Colors.red,
// //       );
// //     } catch (e) {
// //       BotToast.closeAllLoading();
// //       debugPrint('Login Error: $e');
// //       BotToast.showText(
// //         text: "حدث خطأ غير متوقع — تحقق من السيرفر",
// //         contentColor: Colors.red,
// //       );
// //     }
// //   }

// //   // ✅ تسجيل الخروج (مُحسّن)
// //   Future<void> logout() async {
// //     await box.erase();
// //     Get.offAllNamed('/login');
// //   }
// // }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smartcare/Login/login_model.dart';
import 'package:smartcare/buttom_navigation_bar/buttom_navigation_bar.dart';
import 'package:smartcare/config/api_config.dart';

class LoginDoctorController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;

  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      BotToast.showText(
        text: "يرجى تعبئة جميع الحقول",
        contentColor: Colors.red,
      );
      return;
    }

    try {
      BotToast.showLoading();

      final url = Uri.parse("${ApiConfig.baseUrl}/api/doctor/login");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      BotToast.closeAllLoading();

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        BotToast.showText(
          text: data["message"] ?? "خطأ في تسجيل الدخول",
          contentColor: Colors.red,
        );
        return;
      }

      final token = data["token"];
      final doctorJson = data["user"];
      final doctor = DoctorModel.fromJson(doctorJson);

      await box.write("token", token);
      await box.write("doctor", doctor.toJson());
      await box.write("doctorId", doctor.id);
      await box.write("publicKey", doctor.publicKey);
      await box.write("doctor", doctor.toJson());
      await box.write("isLoggedIn", true);
      await box.write("role", doctor.role);

      BotToast.showText(text: "تم تسجيل الدخول بنجاح 🎉");

      Get.off(() => HomeWithBottomNav());
    } on SocketException {
      BotToast.showText(
        text: "لا يوجد اتصال بالإنترنت",
        contentColor: Colors.red,
      );
    } catch (e) {
      BotToast.showText(text: "حدث خطأ غير متوقع", contentColor: Colors.red);
      log("LOGIN ERROR: $e", name: "LoginDoctorController");
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed("/login");
  }
}
