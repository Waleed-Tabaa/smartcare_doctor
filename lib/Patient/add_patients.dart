import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smartcare/Patient/patient_controller.dart';

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientsController>(
      init: PatientsController(),
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              title: const Text("إضافة مريض جديد"),
              backgroundColor: const Color(0xFF3B82F6),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFFE0EBFF),
                      child: Icon(
                        Icons.person_add,
                        size: 50,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionTitle("المعلومات الأساسية", Colors.blue),
                    const SizedBox(height: 8),

                    _inputField("الاسم الكامل", controller.nameCtrl),
                    _inputField(
                      "العمر",
                      controller.ageCtrl,
                      type: TextInputType.number,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: _dropdownDecoration("الجنس"),
                            value: controller.gender,
                            items:
                                ["ذكر", "أنثى"]
                                    .map(
                                      (g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (val) =>
                                    setState(() => controller.gender = val),
                            validator: (val) => val == null ? "مطلوب" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: _dropdownDecoration("فصيلة الدم"),
                            value: controller.bloodType,
                            items:
                                [
                                      "+A",
                                      "-A",
                                      "+B",
                                      "-B",
                                      "+O",
                                      "-O",
                                      "+AB",
                                      "-AB",
                                    ]
                                    .map(
                                      (b) => DropdownMenuItem(
                                        value: b,
                                        child: Text(b),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (val) =>
                                    setState(() => controller.bloodType = val),
                            validator: (val) => val == null ? "مطلوب" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _inputField(
                      "رقم الهاتف",
                      controller.phoneCtrl,
                      type: TextInputType.phone,
                    ),

                    _inputField(
                      "كلمة مرور المريض لتسجيل الدخول",
                      controller.passwordCtrl,
                      obscure: true,
                    ),

                    const SizedBox(height: 20),

                    _sectionTitle("المعلومات الطبية", Colors.green),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      decoration: _dropdownDecoration("نوع المرض"),
                      value: controller.diseaseType,
                      items:
                          ["سكري", "ضغط"]
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => controller.diseaseType = val),
                      validator: (val) => val == null ? "مطلوب" : null,
                    ),
                    const SizedBox(height: 10),

                    _inputField("الحساسية", controller.allergyCtrl),
                    _inputField("نوع الحساسية", TextEditingController()),
                    const SizedBox(height: 10),

                    _inputField("الأمراض المزمنة", controller.chronicCtrl),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      decoration: _dropdownDecoration("حالة المريض"),
                      value: controller.status,
                      items:
                          ["نشط", "يحتاج متابعة", "حرج"]
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => controller.status = val),
                      validator: (val) => val == null ? "مطلوب" : null,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: controller.savePatient,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "حفظ البيانات",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  Widget _inputField(
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
        validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
      ),
    );
  }
}
