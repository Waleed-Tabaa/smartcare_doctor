import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import 'edit_profile_page.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    const mainBlue = Color(0xFF2B7BE4);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GetBuilder<ProfileController>(
        builder: (c) {
          if (c.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          ImageProvider? img;

          if (c.imagePath.isNotEmpty) {
            img = FileImage(File(c.imagePath));
          } else if (c.avatarUrl.isNotEmpty) {
            img = NetworkImage(c.avatarUrl);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mainBlue.withOpacity(.9),
                        const Color(0xFF4EA8FF),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundImage: img,
                        backgroundColor: Colors.white24,
                        child: img == null
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 48)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        c.name.isNotEmpty ? c.name : "دكتور",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        c.about.isNotEmpty ? c.about : "-",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                card("أيام الدوام", c.workingDays.join(", "), Icons.calendar_today),
                card("بداية الدوام", c.startTime, Icons.schedule),
                card("نهاية الدوام", c.endTime, Icons.schedule_outlined),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(() => const EditProfileView()),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text("تعديل الملف الشخصي",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget card(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(child: Text("$title: $value")),
          ],
        ),
      ),
    );
  }
}
