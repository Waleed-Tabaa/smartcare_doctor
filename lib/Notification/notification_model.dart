// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  String message;
  List<Datum> data;

  NotificationModel({required this.message, required this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  int userId;
  String type;
  String title;
  String body;
  int isRead;
  dynamic scheduledAt;
  dynamic sentAt;
  String channel;
  DateTime createdAt;

  Datum({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.scheduledAt,
    required this.sentAt,
    required this.channel,
    required this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    title: json["title"],
    body: json["body"],
    isRead: json["is_read"],
    scheduledAt: json["scheduled_at"],
    sentAt: json["sent_at"],
    channel: json["channel"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "title": title,
    "body": body,
    "is_read": isRead,
    "scheduled_at": scheduledAt,
    "sent_at": sentAt,
    "channel": channel,
    "created_at": createdAt.toIso8601String(),
  };
}
