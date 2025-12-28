// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:smartcare/HomePage/home_page_controller.dart';
// import 'package:smartcare/buttom_navigation_bar/buttom_navigation_bar.dart';

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return GetBuilder<HomeController>(
//       init: HomeController(),
//       builder:
//           (controller) => Scaffold(
//             backgroundColor: Colors.white,
//             body: Stack(
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF4285F4), Color(0xFF6BA4F8)],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),

//                 // موجة بيضاء ناعمة في الأسفل
//                 ClipPath(
//                   clipper: _WaveClipper(),
//                   child: Container(
//                     height: size.height * 0.4,
//                     color: Colors.white,
//                   ),
//                 ),

//                 SafeArea(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // 🌟 ترويسة الطبيب + التاريخ
//                         FadeInDown(
//                           duration: const Duration(milliseconds: 600),
//                           child: Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(18),
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF4285F4), Color(0xFF6BA4F8)],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.blue.withOpacity(0.25),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "مرحباً د. ${controller.doctorName}",
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   controller.specialty,
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.access_time,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       controller.currentDateTime,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 28),

//                         // 🩺 الكروت
//                         FadeInUp(
//                           duration: const Duration(milliseconds: 700),
//                           child: GridView.count(
//                             crossAxisCount: size.width > 600 ? 3 : 2,
//                             childAspectRatio: size.width > 600 ? 1.3 : 1,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             crossAxisSpacing: 16,
//                             mainAxisSpacing: 16,
//                             children: [
//                               GestureDetector(
//                                 behavior: HitTestBehavior.opaque,
//                                 onTap: () {
//                                   Get.find<BottomNavController>().changeIndex(
//                                     2,
//                                   );
//                                 },
//                                 child: _buildInfoCard(
//                                   title: "مواعيد اليوم",
//                                   value:
//                                       controller.todayAppointments.toString(),
//                                   icon: Icons.calendar_today,
//                                   color: Colors.green,
//                                   size: size,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 behavior: HitTestBehavior.opaque,
//                                 onTap: () {
//                                   Get.find<BottomNavController>().changeIndex(
//                                     1,
//                                   );
//                                 },
//                                 child: _buildInfoCard(
//                                   title: "إجمالي المرضى",
//                                   value: controller.patientsCount.toString(),
//                                   icon: Icons.people,
//                                   color: Colors.blue,
//                                   size: size,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 behavior: HitTestBehavior.opaque,
//                                 onTap: () {
//                                   Get.find<BottomNavController>().changeIndex(
//                                     1,
//                                   );
//                                 },
//                                 child: _buildInfoCard(
//                                   title: "حالات حرجة",
//                                   value: controller.criticalCases.toString(),
//                                   icon: Icons.emergency,
//                                   color: Colors.red,
//                                   size: size,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 behavior: HitTestBehavior.opaque,
//                                 onTap: () {
//                                   Get.find<BottomNavController>().changeIndex(
//                                     4,
//                                   );
//                                 },
//                                 child: _buildInfoCard(
//                                   title: "رسائل غير مقروءة",
//                                   value: controller.newMessages.toString(),
//                                   icon: Icons.message,
//                                   color: Colors.purple,
//                                   size: size,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 30),

//                         FadeInUp(
//                           duration: const Duration(milliseconds: 800),
//                           child: const Text(
//                             "إجراءات سريعة",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         FadeInUp(
//                           duration: const Duration(milliseconds: 850),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () {
//                                     Get.find<BottomNavController>().changeIndex(
//                                       2,
//                                     );
//                                     // Get.toNamed("/AppointmentPage");
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 16,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                   ),
//                                   icon: IconButton(
//                                     icon: Icon(
//                                       Icons.calendar_today,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () {
//                                       Get.find<BottomNavController>()
//                                           .changeIndex(2);
//                                       // Get.toNamed("/AppointmentPage");
//                                     },
//                                   ),
//                                   label: const Text(
//                                     "المواعيد",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 14),
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () {
//                                     Get.toNamed("/AddPatientView");
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blue,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 16,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                   ),
//                                   icon: const Icon(
//                                     Icons.person_add,
//                                     color: Colors.white,
//                                   ),
//                                   label: const Text(
//                                     "مريض جديد",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   Widget _buildInfoCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required Size size,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(size.width * 0.04),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: size.width * 0.06,
//             backgroundColor: color.withOpacity(0.1),
//             child: Icon(icon, color: color, size: size.width * 0.06),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: size.width * 0.05,
//               color: Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // 🌊 الموجة الناعمة بالخلفية
// class _WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 50);
//     var firstControlPoint = Offset(size.width / 4, size.height);
//     var firstEndPoint = Offset(size.width / 2, size.height - 40);
//     var secondControlPoint = Offset(3 * size.width / 4, size.height - 80);
//     var secondEndPoint = Offset(size.width, size.height - 30);
//     path.quadraticBezierTo(
//       firstControlPoint.dx,
//       firstControlPoint.dy,
//       firstEndPoint.dx,
//       firstEndPoint.dy,
//     );
//     path.quadraticBezierTo(
//       secondControlPoint.dx,
//       secondControlPoint.dy,
//       secondEndPoint.dx,
//       secondEndPoint.dy,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smartcare/HomePage/home_page_controller.dart';
import 'package:smartcare/buttom_navigation_bar/buttom_navigation_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.box.read('isLoggedIn') != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "لوحة التحكم",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: controller.loading ? null : controller.refresh,
                icon:
                    controller.loading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4285F4), Color(0xFF6BA4F8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              ClipPath(
                clipper: _WaveClipper(),
                child: Container(
                  height: size.height * 0.4,
                  color: Colors.white,
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(controller, size),
                      const SizedBox(height: 28),

                      if (controller.error != null)
                        FadeIn(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.error!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.refresh,
                                  child: const Text(
                                    "إعادة المحاولة",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      _buildStatsGrid(controller, size),
                      const SizedBox(height: 30),

                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: const Text(
                          "إجراءات سريعة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildQuickActions(size),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===== بطاقة الترحيب =====
  Widget _buildHeaderCard(HomeController controller, Size size) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF4285F4), Color(0xFF6BA4F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.loading
                ? _shimmerText(height: 24, width: size.width * 0.6)
                : Text(
                  "مرحباً د. ${controller.doctorName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            const SizedBox(height: 4),
            controller.loading
                ? _shimmerText(height: 16, width: size.width * 0.4)
                : Text(
                  controller.specialty,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 8),
                controller.loading
                    ? _shimmerText(height: 16, width: 120)
                    : Text(
                      controller.currentDateTime,
                      style: const TextStyle(color: Colors.white),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ===== شبكة الإحصائيات =====
  Widget _buildStatsGrid(HomeController controller, Size size) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child:
          controller.loading
              ? _buildLoadingGrid(size)
              : GridView.count(
                crossAxisCount: size.width > 600 ? 3 : 2,
                childAspectRatio: size.width > 600 ? 1.3 : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildInfoCard(
                    title: "مواعيد اليوم",
                    value: controller.todayAppointments.toString(),
                    icon: Icons.calendar_today,
                    color: Colors.green,
                    size: size,
                    onTap: () => Get.find<BottomNavController>().changeIndex(2),
                  ),
                  _buildInfoCard(
                    title: "إجمالي المرضى",
                    value: controller.patientsCount.toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                    size: size,
                    onTap: () => Get.find<BottomNavController>().changeIndex(1),
                  ),
                  _buildInfoCard(
                    title: "حالات حرجة",
                    value: controller.criticalCases.toString(),
                    icon: Icons.emergency,
                    color: Colors.red,
                    size: size,
                    onTap: () => Get.find<BottomNavController>().changeIndex(1),
                  ),
                  _buildInfoCard(
                    title: "رسائل غير مقروءة",
                    value: controller.newMessages.toString(),
                    icon: Icons.message,
                    color: Colors.purple,
                    size: size,
                    onTap: () => Get.find<BottomNavController>().changeIndex(4),
                  ),
                ],
              ),
    );
  }

  /// ===== بطاقة واحدة للإحصائيات =====
  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Size size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: size.width * 0.06,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: size.width * 0.06),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== شيمر =====
  Widget _shimmerText({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.white30,
      highlightColor: Colors.white54,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  /// ===== Grid Loading =====
  Widget _buildLoadingGrid(Size size) {
    return GridView.count(
      crossAxisCount: size.width > 600 ? 3 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: List.generate(4, (_) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shimmerText(height: size.width * 0.12, width: size.width * 0.12),
              const SizedBox(height: 12),
              _shimmerText(height: 16, width: size.width * 0.4),
              const SizedBox(height: 6),
              _shimmerText(height: 20, width: size.width * 0.3),
            ],
          ),
        );
      }),
    );
  }

  /// ===== الإجراءات السريعة =====
  Widget _buildQuickActions(Size size) {
    return FadeInUp(
      duration: const Duration(milliseconds: 850),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Get.find<BottomNavController>().changeIndex(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text(
                "المواعيد",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed("/AddPatientView");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                "مريض جديد",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    var cp1 = Offset(size.width / 4, size.height);
    var ep1 = Offset(size.width / 2, size.height - 40);

    var cp2 = Offset(3 * size.width / 4, size.height - 80);
    var ep2 = Offset(size.width, size.height - 30);

    path.quadraticBezierTo(cp1.dx, cp1.dy, ep1.dx, ep1.dy);
    path.quadraticBezierTo(cp2.dx, cp2.dy, ep2.dx, ep2.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
