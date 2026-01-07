import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vital_controller.dart';

class VitalsPage extends StatelessWidget {
  final int patientId;
  final String patientName;

  const VitalsPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VitalController>(
      init: VitalController()..fetchVitals(patientId),
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),

          appBar: AppBar(
            title: Text("العلامات الحيوية — $patientName"),
            backgroundColor: const Color(0xFF3B82F6),
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF3B82F6),
            onPressed: () => _openAddDialog(context, c),
            child: const Icon(Icons.add, color: Colors.white),
          ),

          body: c.loading
              ? const Center(child: CircularProgressIndicator())
              : c.vitals.isEmpty
                  ? const Center(child: Text("لا توجد قراءات بعد"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: c.vitals.length,
                      itemBuilder: (_, i) {
                        final v = c.vitals[i];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.05),
                              )
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.monitor_heart,
                                          color: Colors.blue),
                                      const SizedBox(width: 6),
                                      Text(
                                        v.type,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      v.source,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                v.auxValue != null
                                    ? "${v.value} / ${v.auxValue}"
                                    : v.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                v.measuredAt,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),

                              if (v.note != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  "ملاحظة: ${v.note!}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                              ],

                              const Divider(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () =>
                                        _openEditDialog(context, c, v),
                                    icon: const Icon(Icons.edit,
                                        color: Colors.orange),
                                    label: const Text("تعديل"),
                                  ),

                                  TextButton.icon(
                                    onPressed: () =>
                                        c.deleteVital(v.id, patientId),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    label: const Text("حذف"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }

  void _openAddDialog(BuildContext context, VitalController c) {
    final type = TextEditingController();
    final value = TextEditingController();
    final aux = TextEditingController();
    final note = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("إضافة قراءة جديدة"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: type, decoration: const InputDecoration(labelText: "نوع القراءة")),
              TextField(controller: value, decoration: const InputDecoration(labelText: "القيمة")),
              TextField(controller: aux, decoration: const InputDecoration(labelText: "قيمة إضافية (اختياري)")),
              TextField(controller: note, decoration: const InputDecoration(labelText: "ملاحظة")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () => c.addVital(
              patientId: patientId,
              type: type.text,
              value: value.text,
              aux: aux.text,
              note: note.text,
            ),
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _openEditDialog(BuildContext context, VitalController c, v) {
    final value = TextEditingController(text: v.value);
    final note = TextEditingController(text: v.note ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تعديل القراءة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: value, decoration: const InputDecoration(labelText: "القيمة")),
            TextField(controller: note, decoration: const InputDecoration(labelText: "ملاحظة")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () =>
                c.updateVital(v.id, patientId, value.text, note.text),
            child: const Text("تحديث"),
          ),
        ],
      ),
    );
  }
}
