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
import 'package:smartcare/MedicalRecords/medical_records_page.dart';
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
import 'package:smartcare/NewPage/new_page.dart';
import 'package:smartcare/LabTests/lab_tests_list_page.dart';
import 'package:smartcare/LabTests/lab_test_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('ar', null);
  log(GetStorage().read("token").toString(), name: "Token");
  log(GetStorage().read("publicKey").toString(), name: "publicKey");
  runApp(SmartCareApp());
}

class SmartCareApp extends StatefulWidget {
  SmartCareApp({super.key});

  @override
  State<SmartCareApp> createState() => _SmartCareAppState();
}

class _SmartCareAppState extends State<SmartCareApp> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Register controllers after first frame so BotToast is initialized
      Get.put(LoginDoctorController());
      Get.put(PatientsController(), permanent: true);
      // Get.put(BottomNavController());
      // Get.put(BottomNavController());
      Get.put(BottomNavController(), permanent: true);

      // Get.put(PatientsController());
      Get.put(HomeController());
      Get.put(ChatController(), permanent: true);
      Get.put(LabTestController());
    });
  }

  @override
  Widget build(BuildContext context) {
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
        GetPage(name: "/NewPage", page: () => NewPage()),
        GetPage(
          name: '/LabTestsListPage',
          page: () => LabTestsListPage(),
          binding: BindingsBuilder(() {
            Get.put(LabTestController());
          }),
        ),
        // GetPage(name: "/MedicalRecordsPage", page: () => MedicalRecordsPage(patientId: null,)),
        GetPage(
          name: "/MedicalRecordsPage",
          page: () {
            final args = Get.arguments;

            return MedicalRecordsPage(
              patientId: args["id"],
              patientName: args["name"],
            );
          },
        ),
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
