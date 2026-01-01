import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/MedicalRecords/medical_records_controller.dart';

class MedicalRecordsPage extends StatelessWidget {
  final int patientId;
  final String patientName;

  const MedicalRecordsPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3B82F6);
    const bg = Color(0xFFF5F7FA);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<MedicalRecordsController>(
        init: MedicalRecordsController()..fetchRecords(patientId),
        builder: (c) {
          return Scaffold(
            backgroundColor: bg,

            appBar: AppBar(
              backgroundColor: primary,
              elevation: 0,
              title: const Text(
                "السجل الطبي",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: primary,
              onPressed: () => _openAddDialog(context, c),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "إضافة سجل",
                style: TextStyle(color: Colors.white),
              ),
            ),

            body:
                c.loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ================= بطاقة المريض =================
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      patientName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primary.withOpacity(.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "متابعة",
                                        style: TextStyle(
                                          color: primary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "سجل طبي شامل للمريض",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "السجلات الطبية",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// ================= عرض السجلات =================
                          if (c.records.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "لا يوجد سجل طبي بعد",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Column(
                              children:
                                  c.records.map((r) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              .05,
                                            ),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// ===== شريط العنوان =====
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    size: 16,
                                                    color: primary,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    r.visitDate,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: primary.withOpacity(
                                                    .15,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  "Check-up",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          _field("التشخيص", r.assessment),
                                          _field("الخطة العلاجية", r.plan),
                                          _field("الملاحظات", r.notes),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed:
                                                  () => c.deleteRecord(
                                                    r.id,
                                                    patientId,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _openAddDialog(
    BuildContext context,
    MedicalRecordsController controller,
  ) {
    final notes = TextEditingController();
    final assessment = TextEditingController();
    final plan = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("إضافة سجل طبي"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: assessment,
                  decoration: const InputDecoration(labelText: "التشخيص"),
                ),
                TextField(
                  controller: plan,
                  decoration: const InputDecoration(
                    labelText: "الخطة العلاجية",
                  ),
                ),
                TextField(
                  controller: notes,
                  decoration: const InputDecoration(labelText: "ملاحظات"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ok = await controller.addRecord(
                    patientId: patientId,
                    visitDate: DateTime.now().toString(),
                    notes: notes.text,
                    assessment: assessment.text,
                    plan: plan.text,
                  );

                  if (ok) Navigator.pop(context);
                },
                child: const Text("حفظ"),
              ),
            ],
          ),
    );
  }
}

Widget _buildInputField(
  String label,
  TextEditingController controller, {
  TextInputType type = TextInputType.text,
  bool obscure = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
