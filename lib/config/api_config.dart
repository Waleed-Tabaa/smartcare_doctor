/// ملف إعدادات API المركزي
/// ضع رابط الـ API هنا في مكان واحد
class ApiConfig {
  // 🔵 رابط السيرفر الأساسي - غيّر هذا الرابط حسب حاجتك
  static const String baseUrl = "https://final-production-8fa9.up.railway.app";
  
  // يمكنك إضافة روابط أخرى هنا إذا احتجتها
  // static const String apiVersion = "/api/v1";
  
  // دالة مساعدة للحصول على الرابط الكامل
  static String getFullUrl(String endpoint) {
    // إزالة الـ slash الأول إذا كان موجوداً
    final cleanEndpoint = endpoint.startsWith('/') 
        ? endpoint.substring(1) 
        : endpoint;
    return "$baseUrl/$cleanEndpoint";
  }
}

