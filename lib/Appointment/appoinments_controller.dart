// lib/appointment/appointments_controller.dart

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:smartcare/Appointment/appoinments_model.dart';
import 'package:smartcare/config/api_config.dart';

class AppointmentController extends GetxController {
  final box = GetStorage();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); 

  DateTime selectedDate = DateTime.now();
  List<Appointment> allAppointments = [];
  List<Appointment> appointments = [];
  List<Map<String, dynamic>> patients = [];
  int? selectedPatientId; 

  Map<String, String> get _headers => {
        "Authorization": "Bearer ${box.read("token")}",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  @override
  void onInit() {
    super.onInit();
    fetchAllAppointments();
    fetchPatients();
  }

  Future<void> fetchAllAppointments() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/appointments"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['appointments'] != null) {
          allAppointments = (data['appointments'] as List)
              .map((e) => Appointment.fromJson(e))
              .toList();
          filterByDate(selectedDate);
        }
      } else {
        log("Error fetching appointments: ${response.statusCode}", name: "AppointmentController.fetchAllAppointments");
      }
    } catch (e) {
      log("Exception in fetchAllAppointments: $e", name: "AppointmentController");
    }
  }

  void filterByDate(DateTime date) {
    selectedDate = date;
    appointments = allAppointments.where((a) {
      return DateFormat('yyyy-MM-dd').format(a.startAt) ==
          DateFormat('yyyy-MM-dd').format(date);
    }).toList();
    update();
  }

  
  void _safeSelectPatient() {
  
    final validPatientIds = patients.map((p) => int.tryParse(p['user_id'].toString())).whereType<int>().toList();

    if (selectedPatientId != null && !validPatientIds.contains(selectedPatientId)) {
      selectedPatientId = null;
    }

    if (selectedPatientId == null && patients.isNotEmpty && validPatientIds.isNotEmpty) {
      selectedPatientId = validPatientIds.first;
    }
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/patients"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['patients'] != null) {
          patients = List<Map<String, dynamic>>.from(data['patients']);
          _safeSelectPatient(); 
          update(); 
        }
      } else {
        log("Error fetching patients: ${response.statusCode}", name: "AppointmentController.fetchPatients");
      }
    } catch (e) {
      log("Exception in fetchPatients: $e", name: "AppointmentController");
    }
  }

  Future<bool> createAppointment({
    required int doctorId,
    required int clinicId,
    required DateTime startAt,
    required DateTime endAt,
    required String reason,
  }) async {
    if (selectedPatientId == null) {
      BotToast.showText(text: "يرجى اختيار المريض");
      return false;
    }

    try {
      BotToast.showLoading();
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/appointments"),
        headers: _headers,
        body: jsonEncode({
          "doctor_id": doctorId,
          "patient_id": selectedPatientId,
          "clinic_id": clinicId,
          "start_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(startAt),
          "end_at": DateFormat('yyyy-MM-dd HH:mm:ss').format(endAt),
          "reason": reason,
        }),
      );

      BotToast.closeAllLoading();
      if (response.statusCode == 200 || response.statusCode == 201) {
        BotToast.showText(text: "تم إنشاء الموعد بنجاح");
        await fetchAllAppointments();
        return true;
      } else {
        final error = jsonDecode(response.body);
        BotToast.showText(text: "فشل: ${error['message'] ?? 'خطأ في إنشاء الموعد'}");
        return false;
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: "حدث خطأ غير متوقع: $e");
      log("Exception in createAppointment: $e", name: "AppointmentController");
      return false;
    }
  }
}