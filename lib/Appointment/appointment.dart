import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartcare/Appointment/appoinments_controller.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  static const Color mainBlue = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(
      init: AppointmentController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: mainBlue,
            title: const Text(
              'المواعيد الطبية',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _openCreateAppointmentSheet(context),
              ),
            ],
          ),
          body: Column(
            children: [
              // ================= هاد جدول التاريخ  =================
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: mainBlue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: controller.selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  onDateChanged: (date) {
                    controller.filterByDate(date);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('d MMMM yyyy', 'ar')
                          .format(controller.selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(${controller.appointments.length})',
                      style: const TextStyle(color: mainBlue),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: controller.appointments.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مواعيد في هذا اليوم',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          final a = controller.appointments[index];

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              title: Text(a.patientName),
                              subtitle: Text(
                                '${DateFormat('HH:mm').format(a.startAt)}'
                                ' - ${DateFormat('HH:mm').format(a.endAt)}'
                                ' • ${a.reason}',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openCreateAppointmentSheet(BuildContext context) {
    final controller = Get.find<AppointmentController>();
    final reasonCtrl = TextEditingController();
    DateTime? startAt;
    DateTime? endAt;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "إنشاء موعد جديد",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (controller.patients.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    DropdownButtonFormField<int>(
                      value: controller.selectedPatientId,
                      items: controller.patients.map((p) {
                        final name =
                            p['full_name'] ??
                            p['name'] ??
                            p['first_name'] ??
                            'مريض بدون اسم';

                        return DropdownMenuItem<int>(
                          value: p['user_id'],
                          child: Text(name.toString()),
                        );
                      }).toList(),
                      onChanged: (v) {
                        controller.selectedPatientId = v;
                      },
                      decoration: const InputDecoration(
                        labelText: "اختر المريض",
                        border: OutlineInputBorder(),
                      ),
                    ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(
                      labelText: "سبب الزيارة",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) {
                        final d = controller.selectedDate;
                        setState(() {
                          startAt = DateTime(
                            d.year,
                            d.month,
                            d.day,
                            t.hour,
                            t.minute,
                          );
                        });
                      }
                    },
                    child: Text(
                      startAt == null
                          ? "اختيار وقت البداية"
                          : DateFormat('HH:mm').format(startAt!),
                    ),
                  ),

                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () async {
                      if (startAt == null) return;
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          startAt!.add(const Duration(minutes: 30)),
                        ),
                      );
                      if (t != null) {
                        setState(() {
                          endAt = DateTime(
                            startAt!.year,
                            startAt!.month,
                            startAt!.day,
                            t.hour,
                            t.minute,
                          );
                        });
                      }
                    },
                    child: Text(
                      endAt == null
                          ? "اختيار وقت النهاية"
                          : DateFormat('HH:mm').format(endAt!),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () async {
                      if (controller.selectedPatientId == null ||
                          startAt == null ||
                          endAt == null ||
                          reasonCtrl.text.isEmpty) {
                        Get.snackbar("تنبيه", "يرجى تعبئة جميع الحقول");
                        return;
                      }

                      await controller.createAppointment(
                        doctorId: 7,
                        clinicId: 1,
                        startAt: startAt!,
                        endAt: endAt!,
                        reason: reasonCtrl.text.trim(),
                      );

                      Get.back();
                    },
                    child: const Text(
                      "إنشاء الموعد",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
