import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/views/sign_in_screen.dart';
import '../views/nutrition_screen.dart';

class MealItem {
  final String name;
  final int minutes;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;
  final int xp;
  final String image;
  final List<String> ingredients;
  final List<String> cookingSteps;
  final int? mealPlanId;
  final String mealType;

  const MealItem({
    required this.name,
    required this.minutes,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.xp,
    required this.image,
    required this.ingredients,
    required this.cookingSteps,
    this.mealPlanId,
    this.mealType = 'breakfast',
  });
}

class MealSection {
  final String title;
  final List<MealItem> items;
  const MealSection({required this.title, required this.items});
}

class NutritionController extends GetxController {
  final isLoading        = true.obs;
  final hasLoadedOnce    = false.obs;
  final selectedDayIndex = 0.obs;
  final isUnlocked       = false.obs;

  final days  = <Map<String, String>>[].obs;
  final meals = <MealSection>[].obs;

  @override
  void onInit() {
    super.onInit();
    _buildDays();
    fetchMealPlan();
  }

  void _buildDays() {
    final today   = DateTime.now().weekday;
    const names   = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final todayIdx = today - 1;

    days.value = List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: todayIdx - i));
      return {
        'day':   '${date.day}',
        'label': names[i],
      };
    });

    selectedDayIndex.value = todayIdx;
  }

  Future<void> fetchMealPlan() async {
    isLoading.value = true;
    const endpoint = AppConstant.mealPlannerEndpoint;

    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final list = data as List;
        if (list.isEmpty) return;

        final plan   = list.first as Map<String, dynamic>;
        final planId = plan['id'] as int?;
        meals.value = [
          _parseSection('Breakfast', plan['breakfast'], planId, 'breakfast'),
          _parseSection('Lunch',     plan['lunch'],     planId, 'lunch'),
          _parseSection('Dinner',    plan['dinner'],    planId, 'dinner'),
        ];
      } else if (response.statusCode == 401) {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    } finally {
      isLoading.value = false;
      hasLoadedOnce.value = true;
    }
  }

  MealSection _parseSection(String title, dynamic raw, int? planId, String mealType) {
    if (raw == null) return MealSection(title: title, items: []);
    final m = raw as Map<String, dynamic>;

    final items    = (m['items']         as List? ?? []).map((e) => e.toString()).toList();
    final ingreds  = (m['ingredients']   as List? ?? []).map((e) => e.toString()).toList();
    final steps    = (m['cooking_steps'] as List? ?? []).map((e) => e.toString()).toList();

    final cookTime = m['cooking_time'] as String? ?? '';
    final minutes  = int.tryParse(cookTime.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final kcalStr   = m['calories'] as String? ?? '0';
    final kcal      = int.tryParse(kcalStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final protStr   = m['protein'] as String? ?? '0';
    final protein   = int.tryParse(protStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final carbStr   = m['carbs'] as String? ?? '0';
    final carbs     = int.tryParse(carbStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final fatStr    = m['fat'] as String? ?? '0';
    final fat       = int.tryParse(fatStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    return MealSection(
      title: title,
      items: [
        MealItem(
          name:         items.isNotEmpty ? items.first : title,
          minutes:      minutes,
          kcal:         kcal,
          protein:      protein,
          carbs:        carbs,
          fat:          fat,
          xp:           50,
          image:        'assets/images/dish.png',
          ingredients:  ingreds,
          cookingSteps: steps,
          mealPlanId:   planId,
          mealType:     mealType,
        ),
      ],
    );
  }

  void selectDay(int index) => selectedDayIndex.value = index;

  void unlock() {
    isUnlocked.value = true;
    Get.back();
  }

  void showPremiumSheetIfNeeded() {
    if (!isUnlocked.value) _showPremiumSheet();
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