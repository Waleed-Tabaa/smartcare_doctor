import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smartcare/LabTests/lab_test_controller.dart';
import 'package:smartcare/Patient/patient_controller.dart';

class AddLabTestPage extends StatefulWidget {
  const AddLabTestPage({super.key});

  @override
  State<AddLabTestPage> createState() => _AddLabTestPageState();
}

class _AddLabTestPageState extends State<AddLabTestPage> {
  final _formKey = GlobalKey<FormState>();
  final _testTypeController = TextEditingController();
  final _labNameController = TextEditingController();
  DateTime? _selectedDueDate;
  int? _selectedPatientId;
  late final LabTestController _labTestController;
  final PatientsController _patientsController = Get.find<PatientsController>();

  // @override
  // void initState() {
  //   super.initState();
  //   _labTestController = Get.find(LabTestController());
  //   _patientsController.fetchPatients();
  // }
  @override
  void initState() {
    super.initState();

    _labTestController = Get.find<LabTestController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _patientsController.fetchPatients();
    });
  }

  @override
  void dispose() {
    _testTypeController.dispose();
    _labNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    if (!mounted) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        setState(() {
          _selectedDueDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPatientId == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار المريض',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedDueDate == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار تاريخ الاستحقاق',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final doctorId = _labTestController.box.read("doctorId");
    if (doctorId == null) {
      Get.snackbar(
        'خطأ',
        'لم يتم العثور على معرف الطبيب',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final dueAt = intl.DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(_selectedDueDate!);

    final success = await _labTestController.createLabTest(
      patientId: _selectedPatientId!,
      orderedByDoctorId: doctorId,
      testType: _testTypeController.text.trim(),
      labName: _labNameController.text.trim(),
      dueAt: dueAt,
    );

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF3B82F6),
          elevation: 0,
          title: const Text(
            'إضافة فحص مختبر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<PatientsController>(
                    builder: (patientsController) {
                      if (patientsController.patientModel.patients.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(width: 16),
                              const Text('جاري تحميل قائمة المرضى...'),
                            ],
                          ),
                        );
                      }

                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'المريض *',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        value: _selectedPatientId,
                        items:
                            patientsController.patientModel.patients.map((
                              patient,
                            ) {
                              return DropdownMenuItem<int>(
                                value: patient.userId,
                                child: Text(patient.fullName),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPatientId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'يرجى اختيار المريض';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _testTypeController,
                    decoration: InputDecoration(
                      labelText: 'نوع الفحص *',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.science),
                      hintText: 'مثال: Blood Glucose',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال نوع الفحص';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _labNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المختبر *',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.business),
                      hintText: 'مثال: SmartCare Lab',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال اسم المختبر';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: _selectDueDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDueDate == null
                                  ? 'تاريخ الاستحقاق *'
                                  : intl.DateFormat(
                                    'yyyy-MM-dd HH:mm',
                                  ).format(_selectedDueDate!),
                              style: TextStyle(
                                color:
                                    _selectedDueDate == null
                                        ? Colors.grey[600]
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إضافة الفحص',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
