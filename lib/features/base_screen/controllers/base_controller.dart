import 'package:flutter/material.dart';
import 'package:get/get.dart';





class BaseController extends GetxController {
  final RxInt currentIndex = 0.obs;
  int lastTapTime = 0;

  // ── Nav keys for each tab ─────────────────────────────────────────────────
  final homeNavKey     = GlobalKey<NavigatorState>();
  final workOutNavKey  = GlobalKey<NavigatorState>();
  final aiCoachNavKey  = GlobalKey<NavigatorState>();
  final nutritionNavKey = GlobalKey<NavigatorState>();
  final levelsNavKey   = GlobalKey<NavigatorState>();
  final progressNavKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  // Public — accessible from BasePage in a different file
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

    // Double-tap → pop to root of that tab
    if (index == currentIndex.value && currentTime - lastTapTime < 500) {
      keyForIndex(index).currentState?.popUntil((route) => route.isFirst);
    } else {
      currentIndex.value = index;
    }

    lastTapTime = currentTime;
  }
}