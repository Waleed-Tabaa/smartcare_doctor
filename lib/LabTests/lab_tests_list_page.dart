import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smartcare/LabTests/lab_test_controller.dart';
import 'package:smartcare/LabTests/lab_test_details_page.dart';
import 'package:smartcare/LabTests/add_lab_test_page.dart';
import 'package:smartcare/LabTests/lab_test_model.dart';

class LabTestsListPage extends StatelessWidget {
  const LabTestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patientId = Get.arguments as int?;
    final controller = Get.find<LabTestController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<LabTestController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              backgroundColor: const Color(0xFF3B82F6),
              elevation: 0,
              title: Text(
                patientId != null ? 'فحوصات المريض' : 'فحوصات المختبر',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                if (patientId != null)
                  IconButton(
                    icon: const Icon(Icons.filter_alt_off, color: Colors.white),
                    onPressed: () {
                      controller.clearFilter();
                      Get.offNamed("/LabTestsListPage");
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => Get.to(() =>  AddLabTestPage()),
                ),
              ],
            ),
            body:
                controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.labTests.isEmpty
                    ? _emptyState()
                    : RefreshIndicator(
                      onRefresh: () => controller.fetchLabTests(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.labTests.length,
                        itemBuilder: (context, index) {
                          final test = controller.labTests[index];
                          return _buildLabTestCard(test, controller);
                        },
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا توجد فحوصات',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLabTestCard(LabTestModel test, LabTestController controller) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: InkWell(
        onTap: () => Get.to(() => LabTestDetailsPage(labTestId: test.id)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        fontSize: 18,
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    test.labName,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    'تاريخ الاستحقاق: ${_formatDate(test.dueAt)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return intl.DateFormat('yyyy-MM-dd', 'ar').format(date);
    } catch (_) {
      return dateString;
    }
  }
}
