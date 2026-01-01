import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'vital_model.dart';

class VitalController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://final-production-8fa9.up.railway.app";

  bool loading = false;
  List<VitalReading> vitals = [];

  String get token => box.read("token") ?? "";

  Future<void> fetchVitals(int patientId) async {
    loading = true;
    update();

    final res = await http.get(
      Uri.parse("$baseUrl/api/vital-readings?patient_id=$patientId"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = json.decode(res.body);

    vitals = (data as List).map((e) => VitalReading.fromJson(e)).toList();

    loading = false;
    update();
  }

  Future<void> deleteVital(int id, int patientId) async {
    await http.delete(
      Uri.parse("$baseUrl/api/vital-readings/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    await fetchVitals(patientId);
  }

  Future<void> addVital({
    required int patientId,
    required String type,
    required String value,
    String? aux,
    String? note,
  }) async {
    await http.post(
      Uri.parse("$baseUrl/api/vital-readings"),
      headers: {"Authorization": "Bearer $token"},
      body: {
        "patient_id": patientId.toString(),
        "type": type,
        "value": value,
        "aux_value": aux ?? "",
        "measured_at": DateTime.now().toString(),
        "source": "MANUAL",
        "note": note ?? "",
      },
    );

    fetchVitals(patientId);
  }

  Future<void> updateVital(
    int id,
    int patientId,
    String value,
    String note,
  ) async {
    await http.put(
      Uri.parse("$baseUrl/api/vital-readings/$id"),
      headers: {"Authorization": "Bearer $token"},
      body: {"value": value, "note": note},
    );

    fetchVitals(patientId);
  }
}
