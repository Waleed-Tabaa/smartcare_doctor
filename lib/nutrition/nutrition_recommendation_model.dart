// lib/nutrition/nutrition_recommendation_model.dart
class NutritionRecommendation {
  final int id;
  final int patientId;
  final String foodName;
  final String mealType;
  final int calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final String description;
  final double confidence;
  final String createdAt; // Keeping as String as per API output

  NutritionRecommendation({
    required this.id,
    required this.patientId,
    required this.foodName,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.description,
    required this.confidence,
    required this.createdAt,
  });

  factory NutritionRecommendation.fromJson(Map<String, dynamic> json) {
    return NutritionRecommendation(
      id: json['id'],
      patientId: json['patient_id'],
      foodName: json['food_name'],
      mealType: json['meal_type'],
      calories: json['calories'],
      protein: json['protein']?.toDouble() ?? 0.0,
      carbohydrates: json['carbohydrates']?.toDouble() ?? 0.0,
      fat: json['fat']?.toDouble() ?? 0.0,
      description: json['description'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
      createdAt: json['created_at'],
    );
  }
}