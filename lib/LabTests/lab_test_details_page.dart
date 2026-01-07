import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smartcare/LabTests/lab_test_controller.dart';
import 'package:smartcare/LabTests/add_lab_result_dialog.dart';

class LabTestDetailsPage extends StatefulWidget {
  final int labTestId;

  const LabTestDetailsPage({super.key, required this.labTestId});

  @override
  State<LabTestDetailsPage> createState() => _LabTestDetailsPageState();
}

class _LabTestDetailsPageState extends State<LabTestDetailsPage> {
  late LabTestController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = Get.put(LabTestController());
  //   controller.fetchLabTestById(widget.labTestId);
  // }
  @override
  void initState() {
    super.initState();
    controller = Get.find<LabTestController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLabTestById(widget.labTestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<LabTestController>(
        builder: (controller) {
          if (controller.isLoading && controller.selectedLabTest == null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF3B82F6),
                title: const Text('تفاصيل الفحص'),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final test = controller.selectedLabTest;
          if (test == null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF3B82F6),
                title: const Text('تفاصيل الفحص'),
              ),
              body: const Center(child: Text('لم يتم العثور على الفحص')),
            );
          }

          Color statusColor;
          String statusText;

          switch (test.status) {
            case 'ORDERED':
              statusColor = Colors.orange;
              statusText = 'مطلوب';
              break;
            case 'COMPLETED':
              statusColor = Colors.green;
              statusText = 'مكتمل';
              break;
            case 'CANCELLED':
              statusColor = Colors.red;
              statusText = 'ملغي';
              break;
            default:
              statusColor = Colors.grey;
              statusText = test.status;
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              backgroundColor: const Color(0xFF3B82F6),
              elevation: 0,
              title: const Text(
                'تفاصيل الفحص',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) async {
                    if (value == 'update_status') {
                      _showStatusUpdateDialog(test.id);
                    } else if (value == 'delete') {
                      _showDeleteDialog(test.id);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'update_status',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('تحديث الحالة'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'حذف الفحص',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                test.testType,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(Icons.business, 'المختبر', test.labName),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'تاريخ الطلب',
                          _formatDate(test.orderedAt),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.event,
                          'تاريخ الاستحقاق',
                          _formatDate(test.dueAt),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // معلومات المريض
                  if (test.patient != null) ...[
                    _buildSectionTitle('معلومات المريض'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.person,
                            'الاسم',
                            test.patient!.fullName,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.wc,
                            'الجنس',
                            test.patient!.gender == 'male' ? 'ذكر' : 'أنثى',
                          ),
                          if (test.patient!.primaryCondition != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.medical_services,
                              'الحالة الأساسية',
                              test.patient!.primaryCondition!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (test.doctor != null) ...[
                    _buildSectionTitle('معلومات الطبيب'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: _buildInfoRow(
                        Icons.person,
                        'الاسم',
                        test.doctor!.fullName,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('النتائج'),
                      if (test.status != 'CANCELLED')
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) =>
                                      AddLabResultDialog(labTestId: test.id),
                            );
                          },
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('إضافة نتيجة'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF3B82F6),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (test.results == null || test.results!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.science_outlined,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد نتائج بعد',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...test.results!.map((result) => _buildResultCard(result)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${result.valueNumeric} ${result.unit}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B82F6),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      _isInRange(result.valueNumeric, result.refRange)
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _isInRange(result.valueNumeric, result.refRange)
                      ? 'طبيعي'
                      : 'غير طبيعي',
                  style: TextStyle(
                    color:
                        _isInRange(result.valueNumeric, result.refRange)
                            ? Colors.green
                            : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'المدى المرجعي: ${result.refRange}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'تاريخ النتيجة: ${_formatDate(result.resultDate)}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          if (result.attachmentUrl != null &&
              result.attachmentUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                // يمكن فتح الملف هنا
              },
              child: Row(
                children: [
                  Icon(Icons.attach_file, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    'عرض المرفق',
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isInRange(String value, String range) {
    try {
      final double numValue = double.parse(value);
      final parts = range.split('-');
      if (parts.length == 2) {
        final min = double.parse(parts[0].trim());
        final max = double.parse(parts[1].trim());
        return numValue >= min && numValue <= max;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return intl.DateFormat('yyyy-MM-dd HH:mm', 'ar').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _showStatusUpdateDialog(int testId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تحديث الحالة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('مطلوب'),
                  leading: Radio<String>(
                    value: 'ORDERED',
                    groupValue: null,
                    onChanged: (value) {
                      Navigator.pop(context);
                      controller.updateLabTestStatus(testId, 'ORDERED');
                    },
                  ),
                ),
                ListTile(
                  title: const Text('مكتمل'),
                  leading: Radio<String>(
                    value: 'COMPLETED',
                    groupValue: null,
                    onChanged: (value) {
                      Navigator.pop(context);
                      controller.updateLabTestStatus(testId, 'COMPLETED');
                    },
                  ),
                ),
                ListTile(
                  title: const Text('ملغي'),
                  leading: Radio<String>(
                    value: 'CANCELLED',
                    groupValue: null,
                    onChanged: (value) {
                      Navigator.pop(context);
                      controller.updateLabTestStatus(testId, 'CANCELLED');
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showDeleteDialog(int testId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من حذف هذا الفحص؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final success = await controller.deleteLabTest(testId);
                  if (success) {
                    Get.back();
                  }
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
