import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/profile/edit_profile_page.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    const mainBlue = Color(0xFF2B7BE4);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: mainBlue,
          title: const Text("الملف الشخصي"),
        ),

        body: GetBuilder<ProfileController>(
          builder: (c) {
            if (c.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            ImageProvider? avatar;

            if (c.imagePath.isNotEmpty) {
              avatar = FileImage(File(c.imagePath));
            } else if (c.avatarUrl.isNotEmpty) {
              avatar = NetworkImage(c.avatarUrl);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: avatar,
                    child:
                        avatar == null
                            ? const Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.grey,
                            )
                            : null,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    c.name.isNotEmpty ? c.name : "اسم غير معروف",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("المعلومات العامة"),

                        infoRow(
                          icon: Icons.person_outline,
                          title: "الجنس",
                          value: c.profileModel.gender ?? "-",
                        ),

                        infoRow(
                          icon: Icons.info_outline,
                          title: "نبذة",
                          value: c.profileModel.bio ?? "-",
                        ),

                        infoRow(
                          icon: Icons.medical_services_outlined,
                          title: "التخصص",
                          value: c.profileModel.specialty?.name ?? "-",
                        ),

                        const SizedBox(height: 15),

                        sectionTitle("معلومات العيادة"),

                        infoRow(
                          icon: Icons.local_hospital,
                          title: "اسم العيادة",
                          value: c.profileModel.clinic?.name ?? "-",
                        ),

                        infoRow(
                          icon: Icons.location_on_outlined,
                          title: "العنوان",
                          value: c.profileModel.clinic?.address ?? "-",
                        ),

                        infoRow(
                          icon: Icons.phone,
                          title: "رقم العيادة",
                          value: c.profileModel.clinic?.phone ?? "-",
                        ),

                        const SizedBox(height: 15),

                        sectionTitle("الدوام"),

                        infoRow(
                          icon: Icons.calendar_month,
                          title: "أيام العمل",
                          value: c.profileModel.workingDays ?? "-",
                        ),

                        infoRow(
                          icon: Icons.access_time,
                          title: "وقت الدوام",
                          value:
                              "${(c.profileModel.startTime ?? '--').toString().substring(0, 5)}  ➜  ${(c.profileModel.endTime ?? '--').toString().substring(0, 5)}",
                        ),

                        infoRow(
                          icon: Icons.nightlight_round,
                          title: "نوع المناوبة",
                          value: c.profileModel.shiftType ?? "-",
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                () => Get.to(() => const EditProfileView()),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text(
                              "تعديل المعلومات",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title:  $value",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
