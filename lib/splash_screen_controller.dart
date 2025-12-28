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
      Get.offAllNamed("/HomeWithBottomNav");
    } else {
      Get.offAllNamed("/login");
    }
  }
}
