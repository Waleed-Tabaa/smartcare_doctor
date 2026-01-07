import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:smartcare/config/api_config.dart';
import 'package:smartcare/nutrition/nutrition_recommendation_model.dart';

class NutritionController extends GetxController {
  final box = GetStorage();

  bool isLoading = false;
  List<NutritionRecommendation> recommendations = [];
  Map<String, List<NutritionRecommendation>> groupedRecommendations = {};

  Map<String, String> get _headers => {
        "Authorization": "Bearer ${box.read("token")}",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

  @override
  void onInit() {
    super.onInit();
    fetchNutritionRecommendations();
  }

  Future<void> fetchNutritionRecommendations() async {
    isLoading = true;
    update();

    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/nutrition/recommendations"),
        headers: _headers,
      );

      log("Nutrition Status: ${response.statusCode}");
      log("Nutrition Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          recommendations = (data['data'] as List)
              .map((e) => NutritionRecommendation.fromJson(e))
              .toList();

          _groupRecommendationsByMealType();
        } else {
          BotToast.showText(text: "فشل جلب البيانات");
        }
      } else {
        BotToast.showText(text: "خطأ بالخادم: ${response.statusCode}");
      }
    } catch (e) {
      log("NUTRITION ERROR => $e");
      BotToast.showText(text: "حدث خطأ غير متوقع");
    } finally {
      isLoading = false;
      update();
    }
  }

  void _groupRecommendationsByMealType() {
    groupedRecommendations.clear();

    for (var rec in recommendations) {
      groupedRecommendations.putIfAbsent(rec.mealType, () => []);
      groupedRecommendations[rec.mealType]!.add(rec);
    }

    update();
  }

  Future<void> approveRecommendation(int id) async {
    BotToast.showText(text: "تمت الموافقة على التوصية");
    await fetchNutritionRecommendations();
  }

  Future<void> deleteRecommendation(int id) async {
    BotToast.showText(text: "تم حذف التوصية");
    await fetchNutritionRecommendations();
  }
}
