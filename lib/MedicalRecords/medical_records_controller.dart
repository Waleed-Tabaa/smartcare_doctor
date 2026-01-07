import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:smartcare/MedicalRecords/medical_records_model.dart';


class MedicalRecordsController extends GetxController {
  final box = GetStorage();

  final String baseUrl = "https://final-production-8fa9.up.railway.app";

  bool loading = false;
  String? error;

  List<MedicalRecordModel> records = [];

  String get _token => box.read("token") ?? "";

  Future<void> fetchRecords(int patientId) async {
    try {
      loading = true;
      error = null;
      update();

      final response = await http.get(
        Uri.parse("$baseUrl/api/medical-records?patient_id=$patientId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        records = (data["records"] as List)
            .map((e) => MedicalRecordModel.fromJson(e))
            .toList();
      } else {
        error = data["message"] ?? "فشل تحميل السجل الطبي";
      }
    } catch (e) {
      error = "حدث خطأ أثناء الاتصال بالسيرفر";
    }

    loading = false;
    update();
  }

  Future<bool> addRecord({
    required int patientId,
    required String visitDate,
    required String notes,
    required String assessment,
    required String plan,
  }) async {
    try {
      loading = true;
      update();

      final response = await http.post(
        Uri.parse("$baseUrl/api/medical-records"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patient_id": patientId,
          "visit_date": visitDate,
          "notes": notes,
          "assessment": assessment,
          "plan": plan,
        }),
      );

      final data = json.decode(response.body);

      loading = false;
      update();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchRecords(patientId);
        Get.snackbar("تم", "تمت إضافة السجل بنجاح");
        return true;
      }

      Get.snackbar("خطأ", data["message"] ?? "تعذر إضافة السجل");
      return false;
    } catch (e) {
      loading = false;
      update();
      Get.snackbar("خطأ", "تعذر الاتصال بالسيرفر");
      return false;
    }
  }

  Future<void> deleteRecord(int id, int patientId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/medical-records/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        await fetchRecords(patientId);
        Get.snackbar("تم", "تم حذف السجل الطبي");
      }
    } catch (_) {
      Get.snackbar("خطأ", "تعذر حذف السجل");
    }
  }
}
