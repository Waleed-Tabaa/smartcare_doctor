import 'package:intl/intl.dart';

class Appointment {
  final int id;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? reason;
  final String patientName;

  Appointment({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.reason,
    required this.patientName,
  });

  static DateTime _parseDate(String value) {
    return DateFormat('yyyy-MM-dd H:mm:ss').parse(value);
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      startAt: _parseDate(json['start_at']),
      endAt: _parseDate(json['end_at']),
      status: json['status'],
      reason: json['reason'],
      patientName: json['patient']?['full_name'] ?? 'مريض غير معروف',
    );
  }
}
