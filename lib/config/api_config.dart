
class ApiConfig {
  static const String baseUrl = "https://final-production-8fa9.up.railway.app";
  
 
  static String getFullUrl(String endpoint) {
    final cleanEndpoint = endpoint.startsWith('/') 
        ? endpoint.substring(1) 
        : endpoint;
    return "$baseUrl/$cleanEndpoint";
  }
}

