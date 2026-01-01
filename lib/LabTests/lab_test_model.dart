class LabTestModel {
  final int id;
  final int patientId;
  final int orderedByDoctorId;
  final String testType;
  final String status;
  final String labName;
  final String orderedAt;
  final String dueAt;
  final Patient? patient;
  final Doctor? doctor;
  final List<LabResult>? results;

  LabTestModel({
    required this.id,
    required this.patientId,
    required this.orderedByDoctorId,
    required this.testType,
    required this.status,
    required this.labName,
    required this.orderedAt,
    required this.dueAt,
    this.patient,
    this.doctor,
    this.results,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    return LabTestModel(
      id: json['id'] ?? 0,
      patientId: json['patient_id'] ?? 0,
      orderedByDoctorId: json['ordered_by_doctor_id'] ?? 0,
      testType: json['test_type'] ?? '',
      status: json['status'] ?? '',
      labName: json['lab_name'] ?? '',
      orderedAt: json['ordered_at'] ?? '',
      dueAt: json['due_at'] ?? '',
      patient: json['patient'] != null ? Patient.fromJson(json['patient']) : null,
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      results: json['results'] != null
          ? (json['results'] as List).map((e) => LabResult.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'ordered_by_doctor_id': orderedByDoctorId,
      'test_type': testType,
      'status': status,
      'lab_name': labName,
      'ordered_at': orderedAt,
      'due_at': dueAt,
      'patient': patient?.toJson(),
      'doctor': doctor?.toJson(),
      'results': results?.map((e) => e.toJson()).toList(),
    };
  }
}

class Patient {
  final int userId;
  final String fullName;
  final String gender;
  final String dob;
  final int? heightCm;
  final String? weightKg;
  final String? primaryCondition;
  final String? address;
  final String? emergencyContact;
  final String? avatarUrl;

  Patient({
    required this.userId,
    required this.fullName,
    required this.gender,
    required this.dob,
    this.heightCm,
    this.weightKg,
    this.primaryCondition,
    this.address,
    this.emergencyContact,
    this.avatarUrl,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      heightCm: json['height_cm'],
      weightKg: json['weight_kg'],
      primaryCondition: json['primary_condition'],
      address: json['address'],
      emergencyContact: json['emergency_contact'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'gender': gender,
      'dob': dob,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'primary_condition': primaryCondition,
      'address': address,
      'emergency_contact': emergencyContact,
      'avatar_url': avatarUrl,
    };
  }
}

class Doctor {
  final int userId;
  final String fullName;
  final String gender;
  final int? primarySpecialtyId;
  final int? clinicId;
  final String? licenseNo;
  final String? bio;
  final String? avatarUrl;
  final String? workingDays;
  final String? startTime;
  final String? endTime;
  final String? shiftType;

  Doctor({
    required this.userId,
    required this.fullName,
    required this.gender,
    this.primarySpecialtyId,
    this.clinicId,
    this.licenseNo,
    this.bio,
    this.avatarUrl,
    this.workingDays,
    this.startTime,
    this.endTime,
    this.shiftType,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      gender: json['gender'] ?? '',
      primarySpecialtyId: json['primary_specialty_id'],
      clinicId: json['clinic_id'],
      licenseNo: json['license_no'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      workingDays: json['working_days'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      shiftType: json['shift_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'gender': gender,
      'primary_specialty_id': primarySpecialtyId,
      'clinic_id': clinicId,
      'license_no': licenseNo,
      'bio': bio,
      'avatar_url': avatarUrl,
      'working_days': workingDays,
      'start_time': startTime,
      'end_time': endTime,
      'shift_type': shiftType,
    };
  }
}

class LabResult {
  final int id;
  final int labTestId;
  final String resultDate;
  final String valueNumeric;
  final String unit;
  final String refRange;
  final String? attachmentUrl;

  LabResult({
    required this.id,
    required this.labTestId,
    required this.resultDate,
    required this.valueNumeric,
    required this.unit,
    required this.refRange,
    this.attachmentUrl,
  });

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      id: json['id'] ?? 0,
      labTestId: json['lab_test_id'] ?? 0,
      resultDate: json['result_date'] ?? '',
      valueNumeric: json['value_numeric'] ?? '',
      unit: json['unit'] ?? '',
      refRange: json['ref_range'] ?? '',
      attachmentUrl: json['attachment_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lab_test_id': labTestId,
      'result_date': resultDate,
      'value_numeric': valueNumeric,
      'unit': unit,
      'ref_range': refRange,
      'attachment_url': attachmentUrl,
    };
  }
}

