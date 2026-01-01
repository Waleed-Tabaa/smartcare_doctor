import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:smartcare/Appointment/appoinments_model.dart';
import 'package:smartcare/config/api_config.dart';

class AppointmentController extends GetxController {
  final box = GetStorage();

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

      log(response.statusCode.toString(),
          name: "fetchAllAppointments statusCode");
      log(response.body.toString(), name: "fetchAllAppointments body");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        allAppointments = (data['appointments'] as List)
            .map((e) => Appointment.fromJson(e))
            .toList();

        filterByDate(selectedDate);
      }
    } catch (_) {}
  }

  void filterByDate(DateTime date) {
    selectedDate = date;

    appointments = allAppointments.where((a) {
      return DateFormat('yyyy-MM-dd').format(a.startAt) ==
          DateFormat('yyyy-MM-dd').format(date);
    }).toList();

    update();
  }

  /// 🔒 حماية من Crash الـ Dropdown
  void safeSelectPatient() {
    final ids = patients.map((e) => e['user_id']).toList();

    if (selectedPatientId != null && !ids.contains(selectedPatientId)) {
      selectedPatientId = null;
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

        patients = List<Map<String, dynamic>>.from(data['patients']);

        safeSelectPatient(); 

        update();
      }
    } catch (_) {}
  }

  Future<bool> createAppointment({
    required int doctorId,
    required int clinicId,
    required DateTime startAt,
    required DateTime endAt,
    required String reason,
  }) async {
    if (selectedPatientId == null) return false;

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
        await fetchAllAppointments();
        return true;
      }

      return false;
    } catch (_) {
      BotToast.closeAllLoading();
      return false;
    }
  }
}
