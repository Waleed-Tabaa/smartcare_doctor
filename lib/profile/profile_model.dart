// To parse this JSON data, do
//
//     final doctorProfile = doctorProfileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DoctorProfile doctorProfileFromJson(String str) =>
    DoctorProfile.fromJson(json.decode(str));

String doctorProfileToJson(DoctorProfile data) => json.encode(data.toJson());

class DoctorProfile {
  int? userId;
  String? fullName;
  dynamic? gender;
  int? primarySpecialtyId;
  int? clinicId;
  dynamic? licenseNo;
  dynamic? bio;
  dynamic? avatarUrl;
  dynamic? workingDays;
  dynamic? startTime;
  dynamic? endTime;
  String? shiftType;
  DateTime? createdAt;
  DateTime? updatedAt;
  Clinic? clinic;
  Specialty? specialty;

  DoctorProfile({
    this.userId,
    this.fullName,
    this.gender,
    this.primarySpecialtyId,
    this.clinicId,
    this.licenseNo,
    this.bio,
    this.avatarUrl,
    this.workingDays,
    this.startTime,
    this.endTime,
    this.shiftType,
    this.createdAt,
    this.updatedAt,
    this.clinic,
    this.specialty,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) => DoctorProfile(
    userId: json["user_id"],
    fullName: json["full_name"],
    gender: json["gender"],
    primarySpecialtyId: json["primary_specialty_id"],
    clinicId: json["clinic_id"],
    licenseNo: json["license_no"],
    bio: json["bio"],
    avatarUrl: json["avatar_url"],
    workingDays: json["working_days"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    shiftType: json["shift_type"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    clinic: json["clinic"] == null ? null : Clinic.fromJson(json["clinic"]),
    specialty:
        json["specialty"] == null
            ? null
            : Specialty.fromJson(json["specialty"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "full_name": fullName,
    "gender": gender,
    "primary_specialty_id": primarySpecialtyId,
    "clinic_id": clinicId,
    "license_no": licenseNo,
    "bio": bio,
    "avatar_url": avatarUrl,
    "working_days": workingDays,
    "start_time": startTime,
    "end_time": endTime,
    "shift_type": shiftType,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "clinic": clinic!.toJson(),
    "specialty": specialty!.toJson(),
  };
}

class Clinic {
  int id;
  String name;
  String address;
  dynamic latitude;
  dynamic longitude;
  String timezone;
  String phone;
  DateTime? createdAt;
  DateTime? updatedAt;

  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    timezone: json["timezone"],
    phone: json["phone"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezone,
    "phone": phone,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Specialty {
  int id;
  String name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Specialty({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) => Specialty(
    id: json["id"],
    name: json["name"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
