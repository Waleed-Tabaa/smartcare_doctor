import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smartcare/Appointment/appointment.dart';
import 'package:smartcare/HomePage/homePage.dart';
import 'package:smartcare/HomePage/home_page_controller.dart';
import 'package:smartcare/Login/Login_doctor.dart';
import 'package:smartcare/Login/Login_doctor_controller.dart';
import 'package:smartcare/Notification/Notification.dart';
import 'package:smartcare/Patient/add_patients.dart';
import 'package:smartcare/Patient/patient_controller.dart';
import 'package:smartcare/buttom_navigation_bar/buttom_navigation_bar.dart';
import 'package:smartcare/chat/chat_controller.dart';
import 'package:smartcare/chat/patients_list_page.dart';
import 'package:smartcare/chat/chat_page.dart';
import 'package:smartcare/profile/edit_profile_page.dart';
import 'package:smartcare/profile/profile_page.dart';
import 'package:smartcare/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('ar', null);
  Get.put(LoginDoctorController());
  Get.put(BottomNavController());
  // Get.put(PatientsController());
  Get.put(HomeController());
  Get.put(ChatController(), permanent: true);
  log(GetStorage().read("token").toString(), name: "Token");
  log(GetStorage().read("publicKey").toString(), name: "publicKey");
  runApp(SmartCareApp());
}

class SmartCareApp extends StatelessWidget {
  final storage = GetStorage();

  SmartCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = storage.read("isLoggedIn") ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SmartCare",
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],

      getPages: <GetPage>[
        GetPage(name: "/splash", page: () => SplashScreen()),

        GetPage(name: "/login", page: () => LoginDoctorPage()),
        GetPage(name: "/home", page: () => HomeView()),
        GetPage(name: "/AppointmentPage", page: () => AppointmentPage()),
        GetPage(name: "/HomeWithBottomNav", page: () => HomeWithBottomNav()),
        GetPage(name: "/PatientsListPage", page: () => PatientsListPage()),
        GetPage(name: "/chat", page: () => ChatPage()),
        GetPage(name: "/ProfileView", page: () => ProfileView()),
        GetPage(name: "/EditProfileView", page: () => EditProfileView()),
        GetPage(name: "/NotificationsPage", page: () => NotificationsPage()),
        GetPage(name: "/AddPatientView", page: () => AddPatientView()),
      ],

      initialRoute: "/splash",

      theme: ThemeData(
        fontFamily: "Cairo",
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}
