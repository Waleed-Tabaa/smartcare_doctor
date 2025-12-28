import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/Patient/patient_controller.dart';

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

    // تشغيل الأنميشن بتدرّج زمني
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
              body: SafeArea(
                child:
                    controller.isLoading
                        ? Container()
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
                                                backgroundColor: Colors
                                                    .blueAccent
                                                    .withOpacity(0.7),
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
                                            hintText:
                                                "ابحث عن مريض بالاسم أو رقم الهاتف...",
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 16,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: controller.selectedCase,
                                        items:
                                            controller.cases.map((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null) {
                                            controller.changeCase(newValue);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                AnimatedBuilder(
                                  animation: _listController,
                                  builder: (context, child) {
                                    final slide = Tween<Offset>(
                                      begin: const Offset(0, 0.3),
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
                                        offset: Offset(0, slide.value.dy * 60),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child:
                                      controller.filteredPatients.isEmpty
                                          ? const Padding(
                                            padding: EdgeInsets.only(top: 40),
                                            child: Text(
                                              "لا يوجد مرضى مطابقين للبحث",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                          : Column(
                                            children:
                                                controller.patientModel.patients.map((
                                                  patient,
                                                ) {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          bottom: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                0.05,
                                                              ),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                    child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 16,
                                                          ),
                                                      leading: CircleAvatar(
                                                        radius: 24,
                                                        backgroundColor:
                                                            const Color(
                                                              0xFFEEF2FF,
                                                            ),
                                                        child: Text(
                                                          patient.fullName
                                                              .substring(0, 1),
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 20,
                                                                color: Color(
                                                                  0xFF3B82F6,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        patient.fullName!,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                patient.gender,
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              // const SizedBox(
                                                              //   width: 8,
                                                              // ),
                                                              // const Icon(
                                                              //   Icons.phone,
                                                              //   color:
                                                              //       Colors.grey,
                                                              //   size: 16,
                                                              // ),
                                                              // const SizedBox(
                                                              //   width: 6,
                                                              // ),
                                                              // Text(
                                                              //   patient["age"]!,
                                                              //   style: const TextStyle(
                                                              //     color:
                                                              //         Colors
                                                              //             .grey,
                                                              //     fontSize: 13,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            // decoration: BoxDecoration(
                                                            //   color:
                                                            //       patient.primaryCondition ==
                                                            //               "نشط"
                                                            //           ? Colors
                                                            //               .green
                                                            //               .shade100
                                                            //           : patient["status"] ==
                                                            //               "يحتاج متابعة"
                                                            //           ? Colors
                                                            //               .amber
                                                            //               .shade100
                                                            //           : Colors
                                                            //               .red
                                                            //               .shade100,
                                                            //   borderRadius:
                                                            //       BorderRadius.circular(
                                                            //         8,
                                                            //       ),
                                                            // ),
                                                            child: Text(
                                                              patient
                                                                  .primaryCondition,
                                                              style: TextStyle(
                                                                // color:
                                                                //     patient["status"] ==
                                                                //             "نشط"
                                                                //         ? Colors
                                                                //             .green
                                                                //             .shade800
                                                                //         : patient["status"] ==
                                                                //             "يحتاج متابعة"
                                                                //         ? Colors
                                                                //             .amber
                                                                //             .shade800
                                                                //         : Colors
                                                                //             .red
                                                                //             .shade800,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          // Text(
                                                          //   patient["blood"]!,
                                                          //   style:
                                                          //       const TextStyle(
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .bold,
                                                          //         color: Color(
                                                          //           0xFF3B82F6,
                                                          //         ),
                                                          //       ),
                                                          // ),
                                                        ],
                                                      ),
                                                      // trailing: Column(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .center,
                                                      //   children: [
                                                      //     Container(
                                                      //       padding:
                                                      //           const EdgeInsets.symmetric(
                                                      //             horizontal: 8,
                                                      //             vertical: 4,
                                                      //           ),
                                                      //       decoration: BoxDecoration(
                                                      //         color:
                                                      //             patient["status"] ==
                                                      //                     "نشط"
                                                      //                 ? Colors
                                                      //                     .green
                                                      //                     .shade100
                                                      //                 : patient["status"] ==
                                                      //                     "يحتاج متابعة"
                                                      //                 ? Colors
                                                      //                     .amber
                                                      //                     .shade100
                                                      //                 : Colors
                                                      //                     .red
                                                      //                     .shade100,
                                                      //         borderRadius:
                                                      //             BorderRadius.circular(
                                                      //               8,
                                                      //             ),
                                                      //       ),
                                                      //       child: Text(
                                                      //         patient["status"]!,
                                                      //         style: TextStyle(
                                                      //           color:
                                                      //               patient["status"] ==
                                                      //                       "نشط"
                                                      //                   ? Colors
                                                      //                       .green
                                                      //                       .shade800
                                                      //                   : patient["status"] ==
                                                      //                       "يحتاج متابعة"
                                                      //                   ? Colors
                                                      //                       .amber
                                                      //                       .shade800
                                                      //                   : Colors
                                                      //                       .red
                                                      //                       .shade800,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .bold,
                                                      //           fontSize: 12,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //     const SizedBox(
                                                      //       height: 6,
                                                      //     ),
                                                      //     Text(
                                                      //       patient["blood"]!,
                                                      //       style:
                                                      //           const TextStyle(
                                                      //             fontWeight:
                                                      //                 FontWeight
                                                      //                     .bold,
                                                      //             color: Color(
                                                      //               0xFF3B82F6,
                                                      //             ),
                                                      //           ),
                                                      //     ),
                                                      //   ],
                                                      // ),
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
            ),
          );
        },
      ),
    );
  }
}
