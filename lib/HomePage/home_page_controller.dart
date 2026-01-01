import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeController extends GetxController {
  final box = GetStorage();

  String doctorName = "";
  String specialty = "";
  int todayAppointments = 5;
  int patientsCount = 120;
  int criticalCases = 3;
  int newMessages = 2;

  String currentDateTime = "";
  late Timer _timer;

  bool loading = false;
  String? error;

  @override
  void onInit() {
    super.onInit();
    _loadDoctorData();
    updateTime();

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) => updateTime(),
    );
  }

  void _loadDoctorData() {
    final user = box.read("doctor");

    doctorName = user?['name'] ?? "محمد";
    specialty = user?['specialty'] ?? "أمراض السكري";
    update();
  }

  void updateTime() {
    currentDateTime = DateFormat(
      'EEEE، d MMM yyyy | HH:mm',
      'ar',
    ).format(DateTime.now());
    update();
  }

  @override
  void refresh() {
    // loading = true;
    // error = null;
    // update();

    // await Future.delayed(const Duration(seconds: 1));

    // loading = false;
    // update();
    super.refresh();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
