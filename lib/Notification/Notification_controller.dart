import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:smartcare/Notification/notification_model.dart';

class NotificationsController extends GetxController {
  final box = GetStorage();

  final String baseUrl = "https://final-production-8fa9.up.railway.app";
  final List<String> filters = ["جميع الإشعارات", "جديدة", "مقروءة"];
  String selectedFilter = "جميع الإشعارات";

  String searchQuery = "";

  final List<Map<String, dynamic>> notifications1 = [
    {
      "id": 1,
      "title": "موعد قادم",
      "body": "لديك موعد مع أحمد محمد الغالي في الساعة 10:00 صباحًا",
      "date": "2025-10-19 10:00",
      "tag": "موعد",
      "isRead": false,
      "priority": "normal",
    },
    {
      "id": 2,
      "title": "تذكير بمتابعة",
      "body": "مريضتك فاطمة سعيد الزهراني بحاجة إلى متابعة دورية خلال أسبوع",
      "date": "2025-10-14 08:00",
      "tag": "تذكير",
      "isRead": false,
      "priority": "high",
    },
    {
      "id": 3,
      "title": "رسالة جديدة",
      "body": "لديك رسالة جديدة من خالد عبدالله الفتحاني",
      "date": "2025-10-13 15:30",
      "tag": "رسالة",
      "isRead": true,
      "priority": "normal",
    },
    {
      "id": 4,
      "title": "نتيجة مختبر",
      "body": "وصلت نتيجة مختبر المريض محمد أحمد - الرجاء الاطلاع",
      "date": "2025-10-12 11:20",
      "tag": "مهم",
      "isRead": true,
      "priority": "critical",
    },
  ];

  bool isLoading = false;

  late NotificationModel notificationModel;

  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      update();
      BotToast.showLoading();

      final rawToken = box.read("token");
      if (rawToken == null) return;

      String token = rawToken.toString();
      log(token.toString(), name: "fetchNotifications token");
      // if (token.startsWith("Bearer ")) {
      //   token = token.substring(7);
      // }

      final response = await http.get(
        Uri.parse("$baseUrl/api/notifications"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      BotToast.closeAllLoading();
      log(
        response.statusCode.toString(),
        name: "fetchNotifications statusCode",
      );
      log(response.body.toString(), name: "fetchNotifications body");

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);
      notificationModel = NotificationModel.fromJson(data);

      update();
    } catch (e) {
    } finally {
      BotToast.closeAllLoading();
      isLoading = false;
      update();
    }
  }

  @override
  Future onInit() async {
    await fetchNotifications();
    _sortNotifications();
    super.onInit();
  }

  void _sortNotifications() {
    notificationModel.data.sort((a, b) {


      final aRead = a.isRead == 0;
      final bRead = b.isRead == 0;
      if (aRead != bRead) return aRead ? 1 : -1;

      // final priOrder = {'critical': 0, 'high': 1, 'normal': 2};
      // final aPri = priOrder[a['priority']] ?? 2;
      // final bPri = priOrder[b['priority']] ?? 2;
      // if (aPri != bPri) return aPri.compareTo(bPri);

      try {
        final aDate = DateTime.parse(a.createdAt.toString());
        final bDate = DateTime.parse(b.createdAt.toString());
        return bDate.compareTo(aDate);
      } catch (e) {
        return 0;
      }
    });
  }

  void changeFilter(String f) {
    selectedFilter = f;
    update();
  }

  void updateSearch(String q) {
    searchQuery = q.trim();
    update();
  }

  int get newCount => notificationModel.data.where((n) => n.isRead == 0).length;

  List<Datum> get filteredNotifications {
    List<Datum> list = List.from(notificationModel.data);

    // فلترنا الاشعارات 
    if (selectedFilter == "جديدة") {
      list = list.where((n) => n.isRead == 0).toList();
    } else if (selectedFilter == "مقروءة") {
      list = list.where((n) => n.isRead == 1).toList();
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list =
          list.where((n) {
            final title = (n.title).toLowerCase();
            final body = (n.body).toLowerCase();
            final date = (n.createdAt.toString()).toLowerCase();
            return title.contains(q) || body.contains(q) || date.contains(q);
          }).toList();
    }

    return list;
  }

  // تعليم إشعار كمقروء
  void markAsRead(int id) {
    final idx = notificationModel.data.indexWhere((n) => n.id == id);
    if (idx != -1 && notificationModel.data[idx].isRead == 0) {
      notificationModel.data[idx].isRead = 1;
      _sortNotifications();
      update();
    }
  }

  void toggleRead(int id) {
    final idx = notificationModel.data.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notificationModel.data[idx].isRead != notificationModel.data[idx].isRead;
      _sortNotifications();
      update();
    }
  }

  void markAllRead() {
    for (var n in notificationModel.data) {
      n.isRead = 1;
    }
    _sortNotifications();
    update();
  }

  void removeNotification(int id) {
    notificationModel.data.removeWhere((n) => n.id == id);
    update();
  }
}
