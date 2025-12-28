import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/profile/edit_profile_page.dart';
import 'package:smartcare/profile/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF2B7BE4);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: GetBuilder<ProfileController>(
            builder: (c) {
              final ImageProvider? profileImage = _buildProfileImage(c);

              return c.isLoading
                  ? Container()
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        // ================= HEADER =================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 28,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                mainBlue.withOpacity(0.85),
                                const Color(0xFF4EA8FF),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(28),
                              bottomRight: Radius.circular(28),
                            ),
                          ),
                          child: Column(
                            children: [
                              // ============== AVATAR ==============
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                backgroundImage: profileImage,
                                child:
                                    profileImage == null
                                        ? const Icon(
                                          Icons.person,
                                          size: 48,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),

                              const SizedBox(height: 12),

                              Text(
                                c.profileModel.fullName!.isNotEmpty
                                    ? c.profileModel.fullName!
                                    : "دكتور غير معروف",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Text(
                              //   c.profileModel.email.isNotEmpty ? c.profileModel.email : "-",
                              //   style: const TextStyle(
                              //     color: Colors.white70,
                              //     fontSize: 13,
                              //   ),
                              // ),
                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _statCard(
                                    "التخصص",
                                    c.profileModel.specialty!.name.isNotEmpty
                                        ? c.profileModel.specialty!.name
                                        : "-",
                                    Icons.medical_services,
                                  ),
                                  const SizedBox(width: 12),
                                  // _statCard(
                                  //   "سنوات الخبرة",
                                  //   c.profileModel.experience.isNotEmpty ? c.profileModel.experience : "0",
                                  //   Icons.star,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ================= CLINIC INFO =================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "معلومات العيادة",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(height: 20),

                                _infoRow(
                                  Icons.local_hospital,
                                  "اسم العيادة",
                                  c.profileModel.clinic!.name.isNotEmpty
                                      ? c.profileModel.clinic!.name
                                      : "-",
                                ),
                                _infoRow(
                                  Icons.location_on,
                                  "العنوان",
                                  c.profileModel.clinic!.address.isNotEmpty
                                      ? c.profileModel.clinic!.address
                                      : "-",
                                ),
                                // _infoRow(
                                //   Icons.access_time,
                                //   "أوقات الدوام",
                                //   c.profileModel.clinicHours.isNotEmpty
                                //       ? c.profileModel.clinicHours
                                //       : "-",
                                // ),
                                _infoRow(
                                  Icons.phone,
                                  "رقم الهاتف",
                                  c.profileModel.clinic!.phone.isNotEmpty
                                      ? c.profileModel.clinic!.phone
                                      : "-",
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ================= EDIT BUTTON =================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed:
                                () => Get.to(() => const EditProfileView()),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text(
                              "تعديل الملف الشخصي",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ================= LOGOUT =================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text(
                              "تسجيل الخروج",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  );
            },
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  ImageProvider? _buildProfileImage(ProfileController c) {
    if (c.imagePath.isNotEmpty) {
      return FileImage(File(c.imagePath));
    }
    if (c.avatarUrl.isNotEmpty && !c.avatarUrl.contains("example.com")) {
      return NetworkImage(c.avatarUrl);
    }
    return null;
  }

  static Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text("$title: $value", style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
