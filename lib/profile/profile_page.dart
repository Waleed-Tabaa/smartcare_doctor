import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/profile/edit_profile_page.dart';
import 'profile_controller.dart';

// class ProfileView extends StatelessWidget {
//   ProfileView({super.key});

//   final c = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     const mainBlue = Color(0xFF2B7BE4);

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: mainBlue,
//           title: const Text(
//             "الملف الشخصي",
//             style: TextStyle(
//               color: Colors.white,
//             ), // Added white color for app bar title
//           ),
//           iconTheme: const IconThemeData(
//             color: Colors.white,
//           ), // Ensures back button is white
//         ),

//         body: GetBuilder<ProfileController>(
//           builder: (c) {
//             if (c.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             ImageProvider? avatar;

//             if (c.imagePath.isNotEmpty) {
//               avatar = FileImage(File(c.imagePath));
//             } else if (c.avatarUrl.isNotEmpty) {
//               avatar = NetworkImage(c.avatarUrl);
//             }

//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 60, // Slightly increased radius for avatar
//                     backgroundColor: Colors.grey.shade300,
//                     backgroundImage: avatar,
//                     child:
//                         avatar == null
//                             ? const Icon(
//                               Icons.person,
//                               size: 60, // Increased icon size
//                               color: Colors.grey,
//                             )
//                             : null,
//                   ),

//                   const SizedBox(height: 16), // Slightly increased spacing

//                   Text(
//                     c.name.isNotEmpty ? c.name : "اسم غير معروف",
//                     style: const TextStyle(
//                       fontSize: 20, // Slightly increased font size
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 30), // Increased spacing

//                   Container(
//                     padding: const EdgeInsets.all(
//                       18,
//                     ), // Slightly increased padding
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                         20,
//                       ), // Slightly increased border radius
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(
//                             .08,
//                           ), // Adjusted shadow for more depth
//                           blurRadius: 12, // Increased blur radius
//                           offset: const Offset(0, 6), // Adjusted offset
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         sectionTitle("المعلومات العامة"),

//                         infoRow(
//                           icon: Icons.person_outline,
//                           title: "الجنس",
//                           value:
//                               c.profileModel.gender ??
//                               "غير محدد", // Changed default to 'غير محدد'
//                         ),
//                         infoRow(
//                           icon: Icons.info_outline,
//                           title: "نبذة",
//                           value:
//                               c.profileModel.bio ??
//                               "لا توجد نبذة", // Changed default
//                         ),
//                         infoRow(
//                           icon: Icons.medical_services_outlined,
//                           title: "التخصص",
//                           value:
//                               c.profileModel.specialty?.name ??
//                               "غير محدد", // Changed default
//                         ),

//                         const SizedBox(height: 20), // Increased spacing

//                         sectionTitle("معلومات العيادة"),

//                         infoRow(
//                           icon: Icons.local_hospital,
//                           title: "اسم العيادة",
//                           value:
//                               c.profileModel.clinic?.name ??
//                               "غير محدد", // Changed default
//                         ),
//                         infoRow(
//                           icon: Icons.location_on_outlined,
//                           title: "العنوان",
//                           value:
//                               c.profileModel.clinic?.address ??
//                               "غير محدد", // Changed default
//                         ),
//                         infoRow(
//                           icon: Icons.phone,
//                           title: "رقم العيادة",
//                           value:
//                               c.profileModel.clinic?.phone ??
//                               "غير متوفر", // Changed default
//                         ),

//                         const SizedBox(height: 20), // Increased spacing

//                         sectionTitle("الدوام"),

//                         infoRow(
//                           icon: Icons.calendar_month,
//                           title: "أيام العمل",
//                           value:
//                               c.profileModel.workingDays ??
//                               "غير محدد", // Changed default
//                         ),
//                         infoRow(
//                           icon: Icons.access_time,
//                           title: "وقت الدوام",
//                           value:
//                               "${(c.profileModel.startTime ?? 'غير محدد').toString().substring(0, 5)}  ➜  ${(c.profileModel.endTime ?? 'غير محدد').toString().substring(0, 5)}", // Changed default
//                         ),
//                         infoRow(
//                           icon: Icons.nightlight_round,
//                           title: "نوع المناوبة",
//                           value:
//                               c.profileModel.shiftType ??
//                               "غير محدد", // Changed default
//                         ),

//                         const SizedBox(height: 28), // Increased spacing

//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed:
//                                 () => Get.to(() => const EditProfileView()),
//                             icon: const Icon(Icons.edit, color: Colors.white),
//                             label: const Text(
//                               "تعديل المعلومات",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 17, // Slightly increased font size
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: mainBlue,
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16,
//                               ), // Increased vertical padding
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   18,
//                                 ), // Slightly increased border radius
//                               ),
//                               elevation: 4, // Added elevation for a subtle lift
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // Enhanced sectionTitle widget
//   Widget sectionTitle(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8, top: 12), // Adjusted padding
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 16, // Slightly increased font size
//           color: Colors.black87, // Darker color for better contrast
//         ),
//       ),
//     );
//   }

//   // Enhanced infoRow widget
//   Widget infoRow({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//       ), // Adjusted vertical padding
//       child: Row(
//         crossAxisAlignment:
//             CrossAxisAlignment.start, // Align text at the start if it wraps
//         children: [
//           Icon(
//             icon,
//             color: Colors.blue.shade700,
//             size: 22,
//           ), // Slightly larger and darker icon
//           const SizedBox(width: 12), // Increased spacing
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "$title:",
//                   style: const TextStyle(
//                     fontSize: 15, // Slightly increased font size
//                     fontWeight: FontWeight.w600, // Make title bolder
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ), // Small space between title and value
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700], // Lighter color for value
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ... existing imports ...

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    const mainBlue = Color(0xFF2B7BE4);
    const lightBlue = Color(0xFFE3F2FD);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
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

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  backgroundColor: mainBlue,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [mainBlue, Color(0xFF1A529B)],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: avatar,
                                child:
                                    avatar == null
                                        ? const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        )
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              c.name.isNotEmpty ? c.name : "اسم غير معروف",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black26, blurRadius: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_note,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Get.to(() => const EditProfileView()),
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Column(
                        children: [
                          _buildModernSection(
                            title: "المعلومات العامة",
                            icon: Icons.person_pin,
                            children: [
                              _buildDetailRow(
                                Icons.wc,
                                "الجنس",
                                c.profileModel.gender ?? "غير محدد",
                              ),
                              _buildDetailRow(
                                Icons.description_outlined,
                                "نبذة",
                                c.profileModel.bio ?? "لا توجد نبذة",
                              ),
                              _buildDetailRow(
                                Icons.workspace_premium,
                                "التخصص",
                                c.profileModel.specialty?.name ?? "غير محدد",
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _buildModernSection(
                            title: "معلومات العيادة",
                            icon: Icons.storefront,
                            color: Colors.green.shade700,
                            children: [
                              _buildDetailRow(
                                Icons.business_rounded,
                                "اسم العيادة",
                                c.profileModel.clinic?.name ?? "غير محدد",
                              ),
                              _buildDetailRow(
                                Icons.location_on_rounded,
                                "العنوان",
                                c.profileModel.clinic?.address ?? "غير محدد",
                              ),
                              _buildDetailRow(
                                Icons.phone_iphone,
                                "رقم العيادة",
                                c.profileModel.clinic?.phone ?? "غير متوفر",
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _buildModernSection(
                            title: "الدوام",
                            icon: Icons.history_toggle_off,
                            color: Colors.orange.shade800,
                            children: [
                              _buildDetailRow(
                                Icons.calendar_today_rounded,
                                "أيام العمل",
                                c.profileModel.workingDays ?? "غير محدد",
                              ),
                              _buildDetailRow(
                                Icons.timer_outlined,
                                "وقت الدوام",
                                "${(c.profileModel.startTime ?? '00:00').toString().substring(0, 5)} - ${(c.profileModel.endTime ?? '00:00').toString().substring(0, 5)}",
                              ),
                              _buildDetailRow(
                                Icons.nights_stay_rounded,
                                "نوع المناوبة",
                                c.profileModel.shiftType ?? "غير محدد",
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Color color = const Color(0xFF2B7BE4),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
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
