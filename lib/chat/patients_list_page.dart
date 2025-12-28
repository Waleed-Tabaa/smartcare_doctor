import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class PatientsListPage extends StatelessWidget {
  const PatientsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (_) {
        // 🔥 هذا السطر هو الحل
        Get.find<ChatController>().fetchConversations();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1976D2),
            title: const Text(
              'المحادثات',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body:
              controller.conversations.isEmpty
                  ? const Center(child: Text('لا توجد محادثات'))
                  : ListView.builder(
                    itemCount: controller.conversations.length,
                    itemBuilder: (context, index) {
                      final c = controller.conversations[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFBBDEFB),
                          child: Icon(Icons.person),
                        ),
                        title: Text(c.name),
                        onTap: () => controller.openConversation(c.id),
                      );
                    },
                  ),
        );
      },
    );
  }
}
