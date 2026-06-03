import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/util/storage_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/util/app_navigation.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      final String? accessToken = StorageService.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
          // AppNavigation.pushAndClear(BasePage());

      } else {
        // AppNavigation.pushAndClear(AccountSelectionScreen());
      }
    });
  }
}
