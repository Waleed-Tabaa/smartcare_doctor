import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';
import 'package:smartcare/config/api_config.dart';
import 'package:smartcare/LabTests/lab_test_model.dart';

class LabTestController extends GetxController {
  final box = GetStorage();

  bool isLoading = false;
  List<LabTestModel> labTests = [];
  List<LabTestModel> allLabTests = [];
  LabTestModel? selectedLabTest;
  int? filteredPatientId;

  Map<String, String> get _headers => {
    "Authorization": "Bearer ${box.read("token")}",
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<void> fetchLabTests() async {
    try {
      isLoading = true;
      update();

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/lab-tests"),
        headers: _headers,
      );

      log(response.statusCode.toString(), name: "fetchLabTests statusCode");
      log(response.body.toString(), name: "fetchLabTests body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['data'] != null && data['data'] is List) {
          allLabTests =
              (data['data'] as List)
                  .map((e) => LabTestModel.fromJson(e))
                  .toList();
        } else if (data is List) {
          allLabTests = data.map((e) => LabTestModel.fromJson(e)).toList();
        } else if (data['lab_tests'] != null && data['lab_tests'] is List) {
          allLabTests =
              (data['lab_tests'] as List)
                  .map((e) => LabTestModel.fromJson(e))
                  .toList();
        }

        _applyFilter();
      }
    } catch (e) {
      log(e.toString(), name: "fetchLabTests error");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchLabTestById(int id) async {
    try {
      isLoading = true;
      update();

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/lab-tests/$id"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        selectedLabTest = LabTestModel.fromJson(data);
      }
    } catch (e) {
      log(e.toString(), name: "fetchLabTestById error");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> createLabTest({
    required int patientId,
    required int orderedByDoctorId,
    required String testType,
    required String labName,
    required String dueAt,
  }) async {
    try {
      BotToast.showLoading();

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/lab-tests"),
        headers: _headers,
        body: jsonEncode({
          "patient_id": patientId,
          "ordered_by_doctor_id": orderedByDoctorId,
          "test_type": testType,
          "lab_name": labName,
          "due_at": dueAt,
        }),
      );

      BotToast.closeAllLoading();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        BotToast.showText(text: data["message"] ?? "تم إنشاء الفحص بنجاح ✅");
        await fetchLabTests();
        return true;
      } else {
        final data = jsonDecode(response.body);
        BotToast.showText(
          text: data["message"] ?? "فشل إنشاء الفحص",
          contentColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(
        text: "حدث خطأ: ${e.toString()}",
        contentColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> updateLabTestStatus(int id, String status) async {
    try {
      BotToast.showLoading();

      final response = await http.put(
        Uri.parse("${ApiConfig.baseUrl}/api/lab-tests/$id"),
        headers: _headers,
        body: jsonEncode({"status": status}),
      );

      BotToast.closeAllLoading();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        BotToast.showText(text: data["message"] ?? "تم تحديث الفحص بنجاح ✏️");
        await fetchLabTests();
        if (selectedLabTest?.id == id) {
          await fetchLabTestById(id);
        }
        return true;
      } else {
        final data = jsonDecode(response.body);
        BotToast.showText(
          text: data["message"] ?? "فشل تحديث الفحص",
          contentColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(
        text: "حدث خطأ: ${e.toString()}",
        contentColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> deleteLabTest(int id) async {
    try {
      BotToast.showLoading();

      final response = await http.delete(
        Uri.parse("${ApiConfig.baseUrl}/api/lab-tests/$id"),
        headers: _headers,
      );

      BotToast.closeAllLoading();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        BotToast.showText(text: data["message"] ?? "تم حذف الفحص بنجاح 🗑️");
        await fetchLabTests();
        return true;
      } else {
        BotToast.showText(text: "فشل حذف الفحص", contentColor: Colors.red);
        return false;
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(
        text: "حدث خطأ: ${e.toString()}",
        contentColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> addLabResult({
    required int labTestId,
    required String resultDate,
    required double valueNumeric,
    required String unit,
    required String refRange,
    String? attachmentUrl,
  }) async {
    try {
      BotToast.showLoading();

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/lab-tests/$labTestId/results"),
        headers: _headers,
        body: jsonEncode({
          "result_date": resultDate,
          "value_numeric": valueNumeric,
          "unit": unit,
          "ref_range": refRange,
          if (attachmentUrl != null) "attachment_url": attachmentUrl,
        }),
      );

      BotToast.closeAllLoading();

      if (response.statusCode == 200 || response.statusCode == 201) {
        BotToast.showText(text: "تم إضافة النتائج بنجاح ✅");
        await fetchLabTestById(labTestId);
        return true;
      } else {
        final data = jsonDecode(response.body);
        BotToast.showText(
          text: data["message"] ?? "فشل إضافة النتائج",
          contentColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(
        text: "حدث خطأ: ${e.toString()}",
        contentColor: Colors.red,
      );
      return false;
    }
  }

  void _applyFilter() {
    if (filteredPatientId != null) {
      labTests =
          allLabTests.where((t) => t.patientId == filteredPatientId).toList();
    } else {
      labTests = List.from(allLabTests);
    }
    update();
  }

  void filterByPatient(int? patientId) {
    filteredPatientId = patientId;
    _applyFilter();
  }

  void clearFilter() {
    filteredPatientId = null;
    _applyFilter();
  }

  void applyInitialFilter(int? patientId) {
    if (patientId != null) {
      filterByPatient(patientId);
    } else {
      clearFilter();
    }
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    await fetchLabTests();

    final patientId = Get.arguments as int?;
    applyInitialFilter(patientId);
  }
}
