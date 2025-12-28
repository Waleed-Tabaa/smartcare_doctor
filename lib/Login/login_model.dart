class DoctorModel {
  final int id;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String publicKey;

  DoctorModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.publicKey,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json["id"],
      email: json["email"],
      phone: json["phone"],
      role: json["role"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      publicKey: json["public_key"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "phone": phone,
      "role": role,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "public_key": publicKey,
    };
  }
}
