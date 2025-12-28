import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreenController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 6), () {
      _navigate();
    });
  }

  void _navigate() {
    bool isLoggedIn = box.read("isLoggedIn") ?? false;

    if (isLoggedIn) {
      // المستخدم مسجّل دخول → روح على الهوم
      Get.offAllNamed("/HomeWithBottomNav");
    } else {
      // غير مسجل دخول → روح على صفحة تسجيل الدخول
      Get.offAllNamed("/login");
    }
  }
}
