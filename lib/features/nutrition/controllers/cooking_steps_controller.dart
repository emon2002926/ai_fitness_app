import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../../auth/views/sign_in_screen.dart';
import 'nutrition_controller.dart';
import 'package:flutter/material.dart';
class Ingredient {
  final String name;
  final String amount;
  final String image;
  const Ingredient({required this.name, required this.amount, required this.image});
}

class CookingStep {
  final int number;
  final String description;
  final bool isDone;
  const CookingStep({required this.number, required this.description, this.isDone = false});
}

class CookingStepsController extends GetxController {
  final MealItem meal;
  CookingStepsController({required this.meal});

  final isFavorite = false.obs;
  final isLogging  = false.obs;

  late final List<Ingredient> ingredients;
  late final List<CookingStep> steps;

  @override
  void onInit() {
    super.onInit();
    ingredients = meal.ingredients.map(_parseIngredient).toList();
    steps = meal.cookingSteps.asMap().entries.map((e) => CookingStep(
      number:      e.key + 1,
      description: e.value,
    )).toList();
  }

  Ingredient _parseIngredient(String raw) {
    final trimmed = raw.trim();
    final parts   = trimmed.split(' ');

    if (parts.length == 1) {
      return Ingredient(name: trimmed, amount: '', image: 'assets/images/orange.png');
    }

    final first = parts[0];
    final isNumeric = double.tryParse(
      first.replaceAll(RegExp(r'[^\d./]'), ''),
    ) != null;

    String amount;
    String name;

    if (isNumeric && parts.length >= 2) {
      final hasUnit = _isUnit(parts[1]);
      if (hasUnit && parts.length >= 3) {
        amount = '${parts[0]} ${parts[1]}';
        name   = parts.sublist(2).join(' ');
      } else {
        amount = parts[0];
        name   = parts.sublist(1).join(' ');
      }
    } else {
      amount = '';
      name   = trimmed;
    }

    name = _stripComma(name);

    return Ingredient(
      name:   name,
      amount: amount,
      image:  'assets/images/orange.png',
    );
  }

  bool _isUnit(String word) {
    const units = {
      'cup', 'cups', 'tablespoon', 'tablespoons', 'tbsp',
      'teaspoon', 'teaspoons', 'tsp', 'g', 'kg', 'ml', 'l',
      'oz', 'lb', 'lbs', 'clove', 'cloves', 'piece', 'pieces',
      'slice', 'slices', 'bunch', 'handful', 'pinch', 'can',
    };
    return units.contains(word.toLowerCase());
  }

  String _stripComma(String s) {
    final idx = s.indexOf(',');
    return idx != -1 ? s.substring(0, idx).trim() : s.trim();
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  Future<void> logMeal(BuildContext context) async {
    if (isLogging.value) return;
    isLogging.value = true;

    const endpoint = AppConstant.logMealEndpoint;
    final body = {
      'meal_plan':  meal.mealPlanId,
      'meal_type':  meal.mealType,
      'fat':        meal.fat,
      'carbs':      meal.carbs,
      'protein':    meal.protein,
    };

    try {
      AppLog.request(endpoint, method: 'POST', body: body);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
          'Content-Type':  'application/json',
        },
        body: jsonEncode(body),
      );

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        AppLog.response(endpoint, data);
        CustomSnackBar.success('Meal logged successfully!');
        if (context.mounted) Navigator.of(context).pop();
      } else if (response.statusCode == 401) {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        CustomSnackBar.error('Failed to log meal. Please try again.');
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Failed to log meal. Please try again.');
    } finally {
      isLogging.value = false;
    }
  }
}