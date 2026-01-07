import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcare/nutrition/nutrition_controller.dart';
import 'package:smartcare/nutrition/nutrition_recommendation_model.dart';

class NutritionRecommendationsPage extends StatelessWidget {
  const NutritionRecommendationsPage({super.key});

  static const Color mainBlue = Color(0xFF2B7BE4);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: mainBlue,
          centerTitle: true,
          title: const Text(
            'توصيات التغذية بالذكاء الاصطناعي',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: GetBuilder<NutritionController>(
          init: NutritionController(),
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.recommendations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fastfood_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "لا توجد توصيات غذائية حاليًا",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: controller.fetchNutritionRecommendations,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        "تحديث",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.groupedRecommendations.entries.map((entry) {
                  final mealType = _translateMealType(entry.key);
                  return _buildMealSection(
                    context,
                    mealType,
                    entry.value,
                    controller,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  // ================== الأقسام ==================

  Widget _buildMealSection(
    BuildContext context,
    String mealType,
    List<NutritionRecommendation> recommendations,
    NutritionController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getMealIcon(mealType), color: mainBlue, size: 26),
              const SizedBox(width: 10),
              Text(
                mealType,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(
                child: Divider(indent: 10, thickness: 1),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ...recommendations.map(
            (rec) => _buildRecommendationCard(context, rec, controller),
          ),
        ],
      ),
    );
  }

  // ================== الكرت ==================

  Widget _buildRecommendationCard(
    BuildContext context,
    NutritionRecommendation recommendation,
    NutritionController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recommendation.foodName.capitalizeFirst ?? recommendation.foodName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              recommendation.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 10),

            _buildNutritionFacts(recommendation),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.approveRecommendation(recommendation.id),
                  icon: const Icon(Icons.check, size: 18, color: Colors.white),
                  label: const Text("موافقة", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => controller.deleteRecommendation(recommendation.id),
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                  label: Text("حذف", style: TextStyle(color: Colors.red.shade700)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ================== القيم الغذائية ==================

  Widget _buildNutritionFacts(NutritionRecommendation rec) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFactItem("سعرات", "${rec.calories} kcal", Colors.orange.shade700),
        _buildFactItem("بروتين", "${rec.protein} g", Colors.blue.shade700),
        _buildFactItem("كربوهيدرات", "${rec.carbohydrates} g", Colors.green.shade700),
        _buildFactItem("دهون", "${rec.fat} g", Colors.red.shade700),
      ],
    );
  }

  Widget _buildFactItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ================== ترجمة نوع الوجبة ==================

  String _translateMealType(String mealType) {
    switch (mealType.toUpperCase()) {
      case 'BREAKFAST':
        return 'وجبة الإفطار';
      case 'LUNCH':
        return 'وجبة الغداء';
      case 'DINNER':
        return 'وجبة العشاء';
      case 'SNACK':
        return 'وجبة خفيفة';
      default:
        return mealType;
    }
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'وجبة الإفطار':
        return Icons.breakfast_dining;
      case 'وجبة الغداء':
        return Icons.lunch_dining;
      case 'وجبة العشاء':
        return Icons.dinner_dining;
      case 'وجبة خفيفة':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }
}
