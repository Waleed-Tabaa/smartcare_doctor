import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smartcare/LabTests/lab_test_controller.dart';

class AddLabResultDialog extends StatefulWidget {
  final int labTestId;

  const AddLabResultDialog({super.key, required this.labTestId});

  @override
  State<AddLabResultDialog> createState() => _AddLabResultDialogState();
}

class _AddLabResultDialogState extends State<AddLabResultDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _unitController = TextEditingController();
  final _refRangeController = TextEditingController();
  final _attachmentUrlController = TextEditingController();
  DateTime? _selectedResultDate;
  final LabTestController _controller = Get.find<LabTestController>();

  @override
  void dispose() {
    _valueController.dispose();
    _unitController.dispose();
    _refRangeController.dispose();
    _attachmentUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectResultDate() async {
    if (!mounted) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'SA'),
    );
    if (picked != null && mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        setState(() {
          _selectedResultDate = DateTime(
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

    if (_selectedResultDate == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار تاريخ النتيجة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final resultDate = intl.DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(_selectedResultDate!);

    final success = await _controller.addLabResult(
      labTestId: widget.labTestId,
      resultDate: resultDate,
      valueNumeric: double.parse(_valueController.text.trim()),
      unit: _unitController.text.trim(),
      refRange: _refRangeController.text.trim(),
      attachmentUrl:
          _attachmentUrlController.text.trim().isEmpty
              ? null
              : _attachmentUrlController.text.trim(),
    );

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إضافة نتيجة الفحص',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'القيمة *',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال القيمة';
                      }
                      if (double.tryParse(value) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _unitController,
                    decoration: InputDecoration(
                      labelText: 'الوحدة *',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.straighten),
                      hintText: 'مثال: mg/dL',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال الوحدة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _refRangeController,
                    decoration: InputDecoration(
                      labelText: 'المدى المرجعي *',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.timeline),
                      hintText: 'مثال: 70-110',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال المدى المرجعي';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectResultDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedResultDate == null
                                  ? 'تاريخ النتيجة *'
                                  : intl.DateFormat(
                                    'yyyy-MM-dd HH:mm',
                                  ).format(_selectedResultDate!),
                              style: TextStyle(
                                color:
                                    _selectedResultDate == null
                                        ? Colors.grey[600]
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _attachmentUrlController,
                    decoration: InputDecoration(
                      labelText: 'رابط المرفق (اختياري)',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.attach_file),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('إلغاء'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إضافة'),
                      ),
                    ],
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
