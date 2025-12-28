import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartcare/Patient/patient_model.dart';

class PatientsController extends GetxController {
  final box = GetStorage();

  final String baseUrl = "https://final-production-8fa9.up.railway.app";

  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String? gender;
  String? bloodType;

  final allergyCtrl = TextEditingController();
  final chronicCtrl = TextEditingController();
  String? status;
  String? diseaseType;

  void savePatient() {
    if (!formKey.currentState!.validate() ||
        gender == null ||
        bloodType == null ||
        diseaseType == null ||
        status == null) {
      Fluttertoast.showToast(
        msg: "يرجى تعبئة جميع الحقول المطلوبة",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16,
      );
      return;
    }

    patients.add({
      "name": nameCtrl.text,
      "phone": phoneCtrl.text,
      "blood": bloodType!,
      "status": status!,
      "age": "${ageCtrl.text} سنة",
    });
    update();

    Fluttertoast.showToast(
      msg: "تم حفظ بيانات المريض بنجاح ",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16,
    );

    Get.back();
  }

  final List<String> cases = [
    "جميع الحالات",
    "نشط",
    "مغلق",
    "يحتاج متابعة",
    "حرج",
  ];

  String selectedCase = "جميع الحالات";
  String searchQuery = "";

  final List<Map<String, String>> patients = [
    {
      "name": "خالد عبدالله الفتحاني",
      "phone": "966503456789+",
      "blood": "+B",
      "status": "نشط",
      "age": "58 سنة",
    },
    {
      "name": "محمد أحمد",
      "phone": "966502345678+",
      "blood": "+O",
      "status": "يحتاج متابعة",
      "age": "45 سنة",
    },
    {
      "name": "عبدالرحمن صالح",
      "phone": "966501234567+",
      "blood": "+A",
      "status": "مغلق",
      "age": "39 سنة",
    },
  ];

  bool isLoading = false;

  late PatientModel patientModel;

  Future<void> fetchPatients() async {
    try {
      isLoading = true;
      update();
      BotToast.showLoading();

      final rawToken = box.read("token");
      if (rawToken == null) return;

      String token = rawToken.toString();
      log(token.toString(), name: "fetchPatients token");
      // if (token.startsWith("Bearer ")) {
      //   token = token.substring(7);
      // }

      final response = await http.get(
        Uri.parse("$baseUrl/api/doctor/my-patients"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      BotToast.closeAllLoading();
      log(response.statusCode.toString(), name: "fetchPatients statusCode");
      log(response.body.toString(), name: "fetchPatients body");

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);
      patientModel = PatientModel.fromJson(data);

      update();
    } catch (e) {
    } finally {
      BotToast.closeAllLoading();
      isLoading = false;
      update();
    }
  }

  @override
  Future onInit() async {
    await fetchPatients();
    super.onInit();
  }

  void changeCase(String newCase) {
    selectedCase = newCase;
    update();
  }

  void updateSearch(String query) {
    searchQuery = query;
    update();
  }

  List<Map<String, String>> get filteredPatients {
    List<Map<String, String>> filtered = patients;

    if (selectedCase != "جميع الحالات") {
      filtered = filtered.where((p) => p["status"] == selectedCase).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (p) =>
                    p["name"]!.contains(searchQuery) ||
                    p["phone"]!.contains(searchQuery),
              )
              .toList();
    }

    return filtered;
  }
}
