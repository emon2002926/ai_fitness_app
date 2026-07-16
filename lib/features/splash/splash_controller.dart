import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../auth/views/sign_in_screen.dart';
import '../base_screen/views/base_page.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 2), () {
      final String? accessToken = StorageService.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        AppNavigation.pushAndClear(const BasePage());
      } else {
        AppNavigation.pushAndClear(const SignInScreen());
      }
    });
  }
}
