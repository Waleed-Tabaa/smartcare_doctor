import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/MedicalRecords/medical_records_page.dart';
import 'package:smartcare/MedicalVitals/vitals_page.dart';
import 'package:smartcare/Patient/patient_controller.dart';
import 'package:smartcare/nutrition/nutrition_recommendations_page.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _headerController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<PatientsController>(
        init: PatientsController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F7FA),

              body:
                  controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _headerController,
                                builder: (context, child) {
                                  final slide = Tween<Offset>(
                                    begin: const Offset(0, -0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _headerController,
                                      curve: Curves.easeOutBack,
                                    ),
                                  );

                                  final fade = Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _headerController,
                                      curve: Curves.easeInOut,
                                    ),
                                  );

                                  return Opacity(
                                    opacity: fade.value,
                                    child: Transform.translate(
                                      offset: Offset(0, slide.value.dy * 50),
                                      child: child,
                                    ),
                                  );
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                color: Colors.white,
                                                size: 26,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "قائمة المرضى",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),

                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Get.toNamed("AddPatientView");
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              "إضافة مريض",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        "إجمالي ${controller.patientModel.count} مريض",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      TextField(
                                        onChanged: controller.updateSearch,
                                        decoration: InputDecoration(
                                          hintText: "ابحث عن مريض بالاسم...",
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 16,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              AnimatedBuilder(
                                animation: _listController,
                                builder: (context, child) {
                                  final slide = Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _listController,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  );

                                  final fade = Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _listController,
                                      curve: Curves.easeInOut,
                                    ),
                                  );

                                  return Opacity(
                                    opacity: fade.value,
                                    child: Transform.translate(
                                      offset: Offset(0, slide.value.dy * 50),
                                      child: child,
                                    ),
                                  );
                                },

                                child: Column(
                                  children:
                                      controller.patientModel.patients.map((
                                        patient,
                                      ) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),

                                          child: ListTile(
                                            onTap:
                                                () => _openPatientOptions(
                                                  context,
                                                  patient,
                                                ),

                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 16,
                                                ),

                                            leading: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: const Color(
                                                0xFFEEF2FF,
                                              ),
                                              child: Text(
                                                patient.fullName.substring(
                                                  0,
                                                  1,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF3B82F6),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            title: Text(
                                              patient.fullName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),

                                            subtitle: Text(
                                              patient.gender,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          );
        },
      ),
    );
  }

  void _openPatientOptions(BuildContext context, patient) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  patient.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 12),

                ListTile(
                  leading: const Icon(Icons.science),
                  title: const Text("فحوصات المريض"),
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed("/LabTestsListPage", arguments: patient.userId);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.medical_information),
                  title: const Text("السجل الطبي"),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(
                      () => MedicalRecordsPage(
                        patientId: patient.userId,
                        patientName: patient.fullName,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monitor_heart),
                  title: const Text("العلامات الحيوية"),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(
                      () => VitalsPage(
                        patientId: patient.userId,
                        patientName: patient.fullName,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: const Text("توصيات غذائية (AI)"),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const NutritionRecommendationsPage());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
