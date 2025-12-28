import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartcare/chat/chat_controller.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatController controller = Get.find();
  final TextEditingController messageCtrl = TextEditingController();

  static const Color myBubble = Color(0xFF1976D2);
  static const Color otherBubble = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          appBar: AppBar(
            backgroundColor: myBubble,
            title: const Text(
              'المحادثة',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child:
                    controller.messages.isEmpty
                        ? const Center(child: Text('لا توجد رسائل بعد'))
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            final m = controller.messages[index];
                            final isMe = m.senderId == controller.myUserId;

                            return Align(
                              alignment:
                                  isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe ? myBubble : otherBubble,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      m.body,
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm').format(m.sentAt),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            isMe
                                                ? Colors.white70
                                                : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
              _inputBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageCtrl,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                filled: true,
                fillColor: const Color(0xFFF0F3F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: myBubble,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                controller.sendMessage(messageCtrl.text);
                messageCtrl.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
