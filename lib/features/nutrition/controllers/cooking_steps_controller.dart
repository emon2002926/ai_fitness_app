import 'package:get/get.dart';

import '../../../core/widgets/snakbar/custom_snackbar.dart';
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

  late final List<Ingredient> ingredients;
  late final List<CookingStep> steps;

  @override
  void onInit() {
    super.onInit();

    ingredients = meal.ingredients.map((raw) {
      final parts  = raw.split(' ');
      final amount = parts.length > 1 ? '${parts[0]} ${parts[1]}' : '';
      final name   = parts.length > 2 ? parts.sublist(2).join(' ') : raw;
      return Ingredient(
        name:   name,
        amount: amount,
        image:  'assets/images/orange.png',
      );
    }).toList();

    steps = meal.cookingSteps.asMap().entries.map((e) => CookingStep(
      number:      e.key + 1,
      description: e.value,
    )).toList();
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  void logMeal(BuildContext context) {
    CustomSnackBar.success('Meal logged successfully!');
    Navigator.of(context).pop();
  }
}
