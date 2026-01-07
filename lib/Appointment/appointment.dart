// lib/appointment/appointment.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartcare/Appointment/appoinments_controller.dart';
import 'package:smartcare/profile/profile_controller.dart'; 

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  static const Color mainBlue = Color(0xFF2B7BE4);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(
      init: AppointmentController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50], 
          appBar: AppBar(
            backgroundColor: mainBlue,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'جدول المواعيد',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                onPressed: () => _openCreateAppointmentSheet(context, controller), 
              ),
            ],
          ),
          body: Column(
            children: [
              
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: mainBlue,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.white, 
                      surface: mainBlue,   
                      onPrimary: mainBlue,  
                      onSurface: Colors.white, 
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(foregroundColor: Colors.white), 
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: controller.selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: controller.filterByDate,
                  ),
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: mainBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_today, color: mainBlue, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, d MMMM', 'ar').format(controller.selectedDate),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const Spacer(),
                    Text(
                      '${controller.appointments.length} مواعيد',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
        
              Expanded(
                child: controller.appointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          final a = controller.appointments[index];
                          return _buildAppointmentCard(a);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(dynamic a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
          child: const Icon(Icons.person, color: mainBlue),
        ),
        title: Text(
          a.patientName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('HH:mm').format(a.startAt)} - ${DateFormat('HH:mm').format(a.endAt)}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(a.reason ?? "لا يوجد سبب محدد", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(a.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _getStatusText(a.status),
            style: TextStyle(color: _getStatusColor(a.status), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("لا توجد مواعيد لهذا اليوم", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  void _openCreateAppointmentSheet(BuildContext context, AppointmentController controller) {
    final profile = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : null;
    final reasonCtrl = TextEditingController();
    DateTime? startAt;
    DateTime? endAt;

   
    controller.selectedPatientId = null; 

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setInternalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Form( 
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("إنشاء موعد جديد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),

                    const Text("اختر المريض", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    controller.patients.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: Text("لا يوجد مرضى متاحون.", style: TextStyle(color: Colors.grey))),
                          )
                        : DropdownButtonFormField<int>(
                            value: controller.selectedPatientId,
                            hint: const Text("الرجاء اختيار مريض"), 
                            items: controller.patients.map((p) {
                              return DropdownMenuItem<int>(
                                value: int.tryParse(p['user_id'].toString()),
                                child: Text(p['full_name'] ?? "مريض بدون اسم"),
                              );
                            }).toList(),
                            onChanged: (v) {
                              setInternalState(() { 
                                controller.selectedPatientId = v;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                            ),
                            validator: (value) => value == null ? "الرجاء اختيار مريض" : null,
                          ),

                    const SizedBox(height: 16),

                    // Reason Field
                    const Text("سبب الزيارة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField( 
                      controller: reasonCtrl,
                      decoration: InputDecoration(
                        hintText: "مثلاً: فحص دوري",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "الرجاء إدخال سبب الزيارة" : null,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeButton(
                            "البداية",
                            startAt,
                            () async {
                              final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                              if (t != null) {
                                setInternalState(() {
                                  startAt = DateTime(controller.selectedDate.year, controller.selectedDate.month, controller.selectedDate.day, t.hour, t.minute);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTimeButton(
                            "النهاية",
                            endAt,
                            () async {
                              if (startAt == null) {
                                Get.snackbar("تنبيه", "يرجى اختيار وقت البداية أولاً", backgroundColor: Colors.orange, colorText: Colors.white);
                                return;
                              }
                              final t = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(startAt!.add(const Duration(minutes: 30))),
                              );
                              if (t != null) {
                                setInternalState(() {
                                  endAt = DateTime(controller.selectedDate.year, controller.selectedDate.month, controller.selectedDate.day, t.hour, t.minute);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    if (startAt == null || endAt == null) 
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("الرجاء اختيار وقتي البداية والنهاية", style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                      ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        if (controller.formKey.currentState?.validate() == false || startAt == null || endAt == null) {
                          Get.snackbar("تنبيه", "يرجى تعبئة جميع الحقول بشكل صحيح", backgroundColor: Colors.orange, colorText: Colors.white);
                          return;
                        }

                        final success = await controller.createAppointment(
                          doctorId: profile?.profileModel.bio ?? 8, 
                          clinicId: profile?.profileModel.clinic?.id ?? 1,
                          startAt: startAt!,
                          endAt: endAt!,
                          reason: reasonCtrl.text.trim(),
                        );

                        if (success) Get.back();
                      },
                      child: const Text("تأكيد الموعد", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTimeButton(String label, DateTime? time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(time == null ? "--:--" : DateFormat('HH:mm').format(time), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return Colors.orange;
      case 'CONFIRMED': return Colors.green;
      case 'CANCELLED': return Colors.red;
      default: return Colors.blue;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return "قيد الانتظار";
      case 'CONFIRMED': return "مؤكد";
      case 'CANCELLED': return "ملغي";
      default: return status;
    }
  }
}