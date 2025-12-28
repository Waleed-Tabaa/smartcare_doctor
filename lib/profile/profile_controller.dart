import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:smartcare/profile/profile_model.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://final-production-8fa9.up.railway.app";
  bool isLoading = false;

  String name = '';
  String email = '';
  String experience = '';
  String about = '';
  String specialty = '';
  String clinicName = '';
  String clinicAddress = '';
  String phone = '';
  String imagePath = '';
  String avatarUrl = '';

  bool hidePassword = true;

  DoctorProfile profileModel = DoctorProfile();

  @override
  Future onInit() async {
    super.onInit();
    await fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      BotToast.showLoading();
      isLoading = true;
      update();

      final rawToken = box.read("token");
      if (rawToken == null) return;

      String token = rawToken.toString();
      log(token.toString(), name: "fetchProfile token");
      // if (token.startsWith("Bearer ")) {
      //   token = token.substring(7);
      // }

      final response = await http.get(
        Uri.parse("$baseUrl/api/doctor/profile/details"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      BotToast.closeAllLoading();
      log(response.statusCode.toString(), name: "fetchProfile statusCode");
      log(response.body.toString(), name: "fetchProfile body");

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);
      profileModel = DoctorProfile.fromJson(data["profile"]);

      name = profileModel!.fullName!;
      about = profileModel!.bio;
      avatarUrl = profileModel!.avatarUrl;
      specialty = profileModel!.specialty!.name;
      clinicName = profileModel!.clinic!.name;
      clinicAddress = profileModel!.clinic!.address;
      phone = profileModel!.clinic!.phone;

      box.write("doctorName", name);
      update();
    } catch (e) {
    } finally {
      BotToast.closeAllLoading();
      isLoading = false;
      update();
    }
  }

  // ================= UPDATE PROFILE API =================
  // Future<bool> updateProfileApi({
  //   required String fullName,
  //   required String bio,
  // }) async {
  //   try {
  //     BotToast.showLoading();

  //     final rawToken = box.read("token");
  //     if (rawToken == null) return false;

  //     String token = rawToken.toString();
  //     if (token.startsWith("Bearer ")) {
  //       token = token.substring(7);
  //     }

  //     final response = await http.post(
  //       Uri.parse("$baseUrl/api/doctor/profile/update"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         "full_name": fullName,
  //         "primary_specialty_id": profileModel!.primarySpecialtyId,
  //         "clinic_id": profileModel!.clinicId,
  //         "bio": bio,
  //         "avatar_url": avatarUrl,
  //       }),
  //     );

  //     BotToast.closeAllLoading();

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       profileModel = DoctorProfile.fromJson(data["profile"]);

  //       name = profileModel!.fullName;
  //       about = profileModel!.bio;
  //       avatarUrl = profileModel!.avatarUrl;

  //       box.write("doctorName", name);
  //       update();
  //       return true;
  //     }

  //     return false;
  //   } catch (e) {
  //     BotToast.closeAllLoading();
  //     return false;
  //   }
  // }

  Future<bool> updateProfileApi({
    required String fullName,
    required String bio,
  }) async {
    try {
      BotToast.showLoading();

      final rawToken = box.read("token");
      if (rawToken == null) return false;

      String token = rawToken.toString();
      // if (token.startsWith("Bearer ")) {
      //   token = token.substring(7);
      // }

      final url = Uri.parse("$baseUrl/api/doctor/profile/update");

      final body = {
        "full_name": fullName,
        "gender": profileModel!.gender,
        "primary_specialty_id": profileModel!.primarySpecialtyId,
        "clinic_id": profileModel!.clinicId,
        "license_no": profileModel!.licenseNo,
        "bio": bio,
        "avatar_url": avatarUrl,
      };

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      log(response.statusCode.toString(), name: "updateProfileApi statusCode");
      log(response.body.toString(), name: "updateProfileApi body");

      BotToast.closeAllLoading();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updated = data["profile"];

        profileModel = DoctorProfile(
          userId: updated["user_id"],
          fullName: updated["full_name"],
          gender: updated["gender"],
          primarySpecialtyId: updated["primary_specialty_id"],
          clinicId: updated["clinic_id"],
          licenseNo: updated["license_no"],
          bio: updated["bio"],
          avatarUrl: updated["avatar_url"] ?? avatarUrl,
          createdAt: profileModel!.createdAt,
          updatedAt: updated["updated_at"],
          clinic: profileModel!.clinic,
          specialty: profileModel!.specialty,
        );

        name = profileModel!.fullName!;
        about = profileModel!.bio;
        avatarUrl = profileModel!.avatarUrl;

        update();
        return true;
      }

      return false;
    } catch (e) {
      BotToast.closeAllLoading();
      return false;
    }
  }

  Future<void> uploadAvatar(File file) async {
    final rawToken = box.read("token");
    if (rawToken == null) return;

    String token = rawToken.toString();
    if (token.startsWith("Bearer ")) {
      token = token.substring(7);
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/doctor/upload-avatar"),
    );

    request.headers["Authorization"] = "Bearer $token";
    request.files.add(await http.MultipartFile.fromPath("avatar", file.path));

    final response = await request.send();
    final resp = await http.Response.fromStream(response);

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      avatarUrl = data["avatar_url"];
      update();
    }
  }
}
