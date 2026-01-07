import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'profile_model.dart';
import 'package:smartcare/config/api_config.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

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

    loadLocalAvatar();   
    await fetchProfile();
  }

  void setLocalAvatar(String path) {
    imagePath = path;
    box.write("local_avatar", path);
    update();
  }

  void loadLocalAvatar() {
    final stored = box.read("local_avatar");
    if (stored != null) imagePath = stored;
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      update();

      final rawToken = box.read("token");
      if (rawToken == null) return;

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/doctor/profile/details"),
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
      endTime = (profileModel.endTime ?? "").toString();

      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<dynamic> updateProfileApi({
    required String fullName,
    required String bio,
    required List<String> days,
    required String start,
    required String end,
  }) async {
    try {
      BotToast.showLoading();

      final token = box.read("token");
      if (token == null) return {"ok": false, "msg": "Token missing"};

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
        Uri.parse("${ApiConfig.baseUrl}/api/doctor/profile/update"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      BotToast.closeAllLoading();

      if (res.statusCode == 422) {
        final data = jsonDecode(res.body);

        final errors = (data["errors"] as Map).entries
            .map((e) => "- ${e.value[0]}")
            .join("\n");

        return {
          "ok": false,
          "msg": data["message"] ?? "Validation error",
          "details": errors,
        };
      }

      if (res.statusCode == 200) {
        await fetchProfile();
        return {"ok": true};
      }

      return {"ok": false, "msg": "Unknown server error"};
    } catch (e) {
      BotToast.closeAllLoading();
      return {"ok": false, "msg": e.toString()};
    }
  }
}
