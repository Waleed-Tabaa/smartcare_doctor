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
          title: const Text(
            "الملف الشخصي",
            style: TextStyle(
              color: Colors.white,
            ), // Added white color for app bar title
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // Ensures back button is white
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
                    radius: 60, // Slightly increased radius for avatar
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: avatar,
                    child:
                        avatar == null
                            ? const Icon(
                              Icons.person,
                              size: 60, // Increased icon size
                              color: Colors.grey,
                            )
                            : null,
                  ),

                  const SizedBox(height: 16), // Slightly increased spacing

                  Text(
                    c.name.isNotEmpty ? c.name : "اسم غير معروف",
                    style: const TextStyle(
                      fontSize: 20, // Slightly increased font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30), // Increased spacing

                  Container(
                    padding: const EdgeInsets.all(
                      18,
                    ), // Slightly increased padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Slightly increased border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            .08,
                          ), // Adjusted shadow for more depth
                          blurRadius: 12, // Increased blur radius
                          offset: const Offset(0, 6), // Adjusted offset
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
                          value:
                              c.profileModel.gender ??
                              "غير محدد", // Changed default to 'غير محدد'
                        ),
                        infoRow(
                          icon: Icons.info_outline,
                          title: "نبذة",
                          value:
                              c.profileModel.bio ??
                              "لا توجد نبذة", // Changed default
                        ),
                        infoRow(
                          icon: Icons.medical_services_outlined,
                          title: "التخصص",
                          value:
                              c.profileModel.specialty?.name ??
                              "غير محدد", // Changed default
                        ),

                        const SizedBox(height: 20), // Increased spacing

                        sectionTitle("معلومات العيادة"),

                        infoRow(
                          icon: Icons.local_hospital,
                          title: "اسم العيادة",
                          value:
                              c.profileModel.clinic?.name ??
                              "غير محدد", // Changed default
                        ),
                        infoRow(
                          icon: Icons.location_on_outlined,
                          title: "العنوان",
                          value:
                              c.profileModel.clinic?.address ??
                              "غير محدد", // Changed default
                        ),
                        infoRow(
                          icon: Icons.phone,
                          title: "رقم العيادة",
                          value:
                              c.profileModel.clinic?.phone ??
                              "غير متوفر", // Changed default
                        ),

                        const SizedBox(height: 20), // Increased spacing

                        sectionTitle("الدوام"),

                        infoRow(
                          icon: Icons.calendar_month,
                          title: "أيام العمل",
                          value:
                              c.profileModel.workingDays ??
                              "غير محدد", // Changed default
                        ),
                        infoRow(
                          icon: Icons.access_time,
                          title: "وقت الدوام",
                          value:
                              "${(c.profileModel.startTime ?? 'غير محدد').toString().substring(0, 5)}  ➜  ${(c.profileModel.endTime ?? 'غير محدد').toString().substring(0, 5)}", // Changed default
                        ),
                        infoRow(
                          icon: Icons.nightlight_round,
                          title: "نوع المناوبة",
                          value:
                              c.profileModel.shiftType ??
                              "غير محدد", // Changed default
                        ),

                        const SizedBox(height: 28), // Increased spacing

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
                                fontSize: 17, // Slightly increased font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ), // Increased vertical padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ), // Slightly increased border radius
                              ),
                              elevation: 4, // Added elevation for a subtle lift
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

  // Enhanced sectionTitle widget
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12), // Adjusted padding
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16, // Slightly increased font size
          color: Colors.black87, // Darker color for better contrast
        ),
      ),
    );
  }

  // Enhanced infoRow widget
  Widget infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ), // Adjusted vertical padding
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align text at the start if it wraps
        children: [
          Icon(
            icon,
            color: Colors.blue.shade700,
            size: 22,
          ), // Slightly larger and darker icon
          const SizedBox(width: 12), // Increased spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title:",
                  style: const TextStyle(
                    fontSize: 15, // Slightly increased font size
                    fontWeight: FontWeight.w600, // Make title bolder
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ), // Small space between title and value
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700], // Lighter color for value
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
