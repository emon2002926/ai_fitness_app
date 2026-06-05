import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../nutrition/controllers/nutrition_controller.dart';





class BaseController extends GetxController {
  final RxInt currentIndex = 0.obs;
  int lastTapTime = 0;

  final homeNavKey     = GlobalKey<NavigatorState>();
  final workOutNavKey  = GlobalKey<NavigatorState>();
  final aiCoachNavKey  = GlobalKey<NavigatorState>();
  final nutritionNavKey = GlobalKey<NavigatorState>();
  final levelsNavKey   = GlobalKey<NavigatorState>();
  final progressNavKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  GlobalKey<NavigatorState> keyForIndex(int index) {
    switch (index) {
      case 1:  return workOutNavKey;
      case 2:  return aiCoachNavKey;
      case 3:  return nutritionNavKey;
      case 4: return levelsNavKey;
      case 5: return progressNavKey;

      default: return homeNavKey;
    }
  }

  void onTabSelected(int index) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (index == currentIndex.value && currentTime - lastTapTime < 500) {
      keyForIndex(index).currentState?.popUntil((route) => route.isFirst);
    } else {
      currentIndex.value = index;

      if (index == 3) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final nutritionController = Get.find<NutritionController>();
          nutritionController.showPremiumSheetIfNeeded();
        });
      }
    }

    lastTapTime = currentTime;
  }


}