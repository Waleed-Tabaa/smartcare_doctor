import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/HomePage/homePage.dart';
import 'package:smartcare/Notification/Notification.dart';
import 'package:smartcare/Patient/patient.dart';
import 'package:smartcare/chat/patients_list_page.dart';
import 'package:smartcare/Appointment/appointment.dart';
import 'package:smartcare/profile/profile_page.dart';

class HomeWithBottomNav extends GetView<BottomNavController> {
  const HomeWithBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (controller) {
        return Scaffold(
          body: _getBody(controller.currentIndex),
          bottomNavigationBar: CupertinoTabBar(
            backgroundColor: Colors.white,
            currentIndex: controller.currentIndex,
            activeColor: Color.fromARGB(255, 17, 183, 243),
            inactiveColor: CupertinoColors.systemGrey2,
            onTap: (index) {
              controller.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'المرضى',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_turned_in),
                label: 'المواعيد',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'الدردشة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "التنبيهات",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
            ],
          ),
        );
      },
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const HomeView(); 
      case 1:
        return PatientsPage();
      case 2:
        return AppointmentPage();
      case 3:
        return PatientsListPage();
      case 4:
        return NotificationsPage();

      case 5:
        return ProfileView();

      default:
        return const Center(child: Text('لا توجد بيانات'));
    }
  }
}

class BottomNavController extends GetxController {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    update();
  }
}
