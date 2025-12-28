import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smartcare/chat/chat_convarsation_model.dart';
import 'package:smartcare/chat/chat_model.dart';

class ChatController extends GetxController {
  final box = GetStorage();
  final baseUrl = "https://final-production-8fa9.up.railway.app";

  final int myUserId = 8; 

  List<Conversation> conversations = [];
  List<ChatMessage> messages = [];

  int? currentConversationId;

  Map<String, String> get headers => {
    "Authorization": "Bearer ${box.read('token')}",
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<void> fetchConversations() async {
    final res = await http.get(
      Uri.parse("$baseUrl/api/chat/conversations"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print('RAW CONVERSATIONS => ${data['conversations']}');
      conversations =
          (data['conversations'] as List)
              .map((e) => Conversation.fromJson(e, myUserId))
              .toList();
      update();
    }
  }

  Future<void> openConversation(int id) async {
    print('OPEN CHAT ID => $id');

    currentConversationId = id;

    final res = await http.get(
      Uri.parse("$baseUrl/api/chat/conversations/$id/messages"),
      headers: headers,
    );

    print('STATUS => ${res.statusCode}');
    print('RAW MESSAGES => ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      messages =
          (data['messages'] as List)
              .map((e) => ChatMessage.fromJson(e))
              .toList();

      update();
      Get.toNamed('/chat');
    }
  }

  // ====== SEND MESSAGE ======
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || currentConversationId == null) return;

    final res = await http.post(
      Uri.parse("$baseUrl/api/chat/messages"),
      headers: headers,
      body: jsonEncode({
        "conversation_id": currentConversationId,
        "body": text, // نص عادي
        "attachment_url": null,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      // ChatMessage(
      //     id: data['data']['id'],
      //     body: text,
      //     senderId: data['data']['sender_user_id'],
      //     sentAt: data['data']['sent_at'],
      //   );
      var responseMap = '''{
        "message": "Message sent successfully ✅",
        "data": {
          "sender_user_id": ${data['data']['sender_user_id']},
          "body": "$text",
          "attachment_url": null,
          "sent_at": "${data['data']['sent_at']}",
          "id": ${data['data']['id']}
        }
      }''';
      final data2 = jsonDecode(responseMap);
      messages.add(ChatMessage.fromJson(data2['data']));
      // messages.add(ChatMessage.fromJson(data['data']));
      update();
    }
  }
}
