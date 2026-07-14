import 'dart:async';
import 'package:ai_fitness_app/features/auth/views/sign_in_screen.dart';
import 'package:get/get.dart';
import '../../../../core/util/storage_service.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/util/app_navigation.dart';
import '../base_screen/views/base_page.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      String? accessToken = StorageService.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        AppNavigation.pushAndClear( BasePage());
        // Get.offAll(BasePage());

        // AppNavigation.pushAndClear(Get.context!, SubscriptionPage());

      } else {
        // No token, navigate to onboarding
        // Get.offAll(SignInScreen());
        AppNavigation.pushAndClear(SignInScreen());
      }
    });
  }

}