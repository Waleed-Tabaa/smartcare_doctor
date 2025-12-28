import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'profile_model.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://final-production-8fa9.up.railway.app";

  bool isLoading = false;

  String name = "";
  String about = "";
  String avatarUrl = "";
  String imagePath = "";

  List<String> workingDays = [];
  String startTime = "";
  String endTime = "";

  DoctorProfile profileModel = DoctorProfile();

  @override
  Future onInit() async {
    super.onInit();
    await fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      update();

      final rawToken = box.read("token");
      if (rawToken == null) return;

      final response = await http.get(
        Uri.parse("$baseUrl/api/doctor/profile/details"),
        headers: {
          "Authorization": "Bearer $rawToken",
          "Accept": "application/json",
        },
      );

      log(response.body, name: "fetchProfile");

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);
      profileModel = DoctorProfile.fromJson(data["profile"]);

      name = profileModel.fullName ?? "";
      about = profileModel.bio ?? "";
      avatarUrl = profileModel.avatarUrl ?? "";

      workingDays = (profileModel.workingDays ?? "")
          .toString()
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      startTime = (profileModel.startTime ?? "").toString();
      endTime   = (profileModel.endTime ?? "").toString();

      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> updateProfileApi({
    required String fullName,
    required String bio,
    required List<String> days,
    required String start,
    required String end,
  }) async {
    try {
      BotToast.showLoading();

      final rawToken = box.read("token");
      if (rawToken == null) return false;

      final body = {
        "full_name": fullName,
        "gender": profileModel.gender ?? "male",
        "primary_specialty_id": profileModel.primarySpecialtyId,
        "clinic_id": profileModel.clinicId,
        "license_no": profileModel.licenseNo,
        "bio": bio,
        "avatar_url": avatarUrl,
        "working_days": days.join(", "),
        "start_time": start,
        "end_time": end,
      };

      final res = await http.post(
        Uri.parse("$baseUrl/api/doctor/profile/update"),
        headers: {
          "Authorization": "Bearer $rawToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      log(res.body, name: "updateProfileApi");

      BotToast.closeAllLoading();

      if (res.statusCode == 200) {
        await fetchProfile();   // ← مهم لعرض التحديث فورًا
        return true;
      }

      return false;
    } catch (_) {
      BotToast.closeAllLoading();
      return false;
    }
  }

  Future<void> uploadAvatar(File file) async {
    final rawToken = box.read("token");
    if (rawToken == null) return;

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/doctor/upload-avatar"),
    );

    request.headers["Authorization"] = "Bearer $rawToken";
    request.files.add(await http.MultipartFile.fromPath("avatar", file.path));

    final response = await request.send();
    final resp = await http.Response.fromStream(response);

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      avatarUrl = data["avatar_url"];

      imagePath = "";     // ← نوقف FileImage
      await fetchProfile(); // ← يحدّث الشاشتين
    }

    update();
  }
}
