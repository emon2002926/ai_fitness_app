import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../auth/views/sign_in_screen.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  static const int totalOnboardingPages = 3;
  static const int totalPages = 4;

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    pageController.animateToPage(
      totalOnboardingPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void getStarted(BuildContext context) => AppNavigation.push(SignInScreen(),context: context);
  void login() => AppNavigation.push(SignInScreen());

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
