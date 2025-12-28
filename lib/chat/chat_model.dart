import 'package:smartcare/chat/chat_crypto.dart';

class ChatMessage {
  final int id;
  final int senderId;
  final String body;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.body,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // final encryptedBody = json['body'];

    // final text =
    //     encryptedBody is String ? ChatCrypto.decryptMessage(encryptedBody) : '';

    return ChatMessage(
      id: json['id'],
      senderId: json['sender_user_id'],
      body: json['body'] ?? "",
      sentAt: DateTime.parse(json['sent_at'].toString().replaceFirst(' ', 'T')),
    );
  }
}
