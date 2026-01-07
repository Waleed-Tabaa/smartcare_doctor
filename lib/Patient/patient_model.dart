import 'dart:convert';

PatientModel patientModelFromJson(String str) =>
    PatientModel.fromJson(json.decode(str));

String patientModelToJson(PatientModel data) => json.encode(data.toJson());

class PatientModel {
  String message;
  int count;
  List<Patient> patients;

  PatientModel({
    required this.message,
    required this.count,
    required this.patients,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
    message: json["message"] ?? "",
    count: json["count"] ?? 0,
    patients:
        json["patients"] == null
            ? []
            : List<Patient>.from(
              json["patients"].map((x) => Patient.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "count": count,
    "patients": List<dynamic>.from(patients.map((x) => x.toJson())),
  };
}

class Patient {
  int userId;
  String fullName;
  String gender;

  /// قد يكون null من الـ API
  String? avatarUrl;

  String primaryCondition;

  Patient({
    required this.userId,
    required this.fullName,
    required this.gender,
    this.avatarUrl,
    required this.primaryCondition,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    userId: json["user_id"],
    fullName: json["full_name"] ?? "",
    gender: json["gender"] ?? "",
    avatarUrl: json["avatar_url"] ?? "",
    primaryCondition: json["primary_condition"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "full_name": fullName,
    "gender": gender,
    "avatar_url": avatarUrl,
    "primary_condition": primaryCondition,
  };
}
