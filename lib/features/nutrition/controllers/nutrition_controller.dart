import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/nutrition_screen.dart';

class MealItem {
  final String name;
  final int minutes;
  final int kcal;
  final int protein;
  final int xp;
  final String image;

  const MealItem({
    required this.name,
    required this.minutes,
    required this.kcal,
    required this.protein,
    required this.xp,
    required this.image,
  });
}

class MealSection {
  final String title;
  final List<MealItem> items;

  const MealSection({required this.title, required this.items});
}

class NutritionController extends GetxController {
  final selectedDayIndex = 2.obs;
  final isUnlocked = false.obs;

  final days = <Map<String, String>>[
    {'day': '2', 'label': 'WED'},
    {'day': '3', 'label': 'THU'},
    {'day': '4', 'label': 'FRI'},
    {'day': '5', 'label': 'SAT'},
    {'day': '6', 'label': 'SUN'},
    {'day': '7', 'label': 'MON'},
    {'day': '8', 'label': 'TUE'},
  ];

  final meals = <MealSection>[
    MealSection(
      title: 'Breakfast',
      items: [
        MealItem(
          name: 'grilled chicken skewers',
          minutes: 35,
          kcal: 450,
          protein: 50,
          xp: 50,
          image: 'assets/images/dish.png',
        ),
      ],
    ),
    MealSection(
      title: 'Lunch',
      items: [
        MealItem(
          name: 'grilled chicken skewers',
          minutes: 35,
          kcal: 450,
          protein: 50,
          xp: 50,
          image: 'assets/images/dish.png',
        ),
      ],
    ),
    MealSection(
      title: 'Dinner',
      items: [
        MealItem(
          name: 'grilled chicken skewers',
          minutes: 35,
          kcal: 450,
          protein: 50,
          xp: 50,
          image: 'assets/images/dish.png',
        ),
      ],
    ),
  ];

  void selectDay(int index) => selectedDayIndex.value = index;

  void unlock() {
    // TODO: call payment API
    isUnlocked.value = true;
    Get.back();
  }

  void showPremiumSheetIfNeeded() {
    if (!isUnlocked.value) {
      _showPremiumSheet();
    }
  }

  void _showPremiumSheet() {
    Get.bottomSheet(
      const PremiumBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }
}