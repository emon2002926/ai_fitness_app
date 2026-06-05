import 'package:get/get.dart';

import '../../../core/widgets/snakbar/custom_snackbar.dart';
import 'nutrition_controller.dart';
import 'package:flutter/material.dart';
class Ingredient {
  final String name;
  final String amount;
  final String image;

  const Ingredient({
    required this.name,
    required this.amount,
    required this.image,
  });
}

class CookingStep {
  final int number;
  final String description;
  final bool isDone;

  const CookingStep({
    required this.number,
    required this.description,
    this.isDone = false,
  });
}

class CookingStepsController extends GetxController {
  final MealItem meal;

  CookingStepsController({required this.meal});

  final isFavorite = false.obs;

  final ingredients = <Ingredient>[
    const Ingredient(name: 'Orange', amount: '500g', image: 'assets/images/ing_orange.png'),
    const Ingredient(name: 'Lettuce', amount: '500g', image: 'assets/images/ing_lettuce.png'),
    const Ingredient(name: 'Cucumbers', amount: '500g', image: 'assets/images/ing_cucumber.png'),
    const Ingredient(name: 'Tomato', amount: '500g', image: 'assets/images/ing_tomato.png'),
  ];

  final steps = <CookingStep>[
    const CookingStep(
      number: 1,
      description: 'Grill the zucchini and yellow squash slices on a grill or pan until nicely charred. Set aside to cool.',
      isDone: true,
    ),
    const CookingStep(
      number: 2,
      description: 'Grill the zucchini and yellow squash slices on a grill or pan until nicely charred. Set aside to cool.',
      isDone: true,
    ),
    const CookingStep(
      number: 3,
      description: 'Grill the zucchini and yellow squash slices on a grill or pan until nicely charred. Set aside to cool.',
      isDone: false,
    ),
  ];

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  void logMeal(BuildContext context) {
    // TODO: call API
    CustomSnackBar.success('Meal logged successfully!');
    Navigator.of(context).pop();
  }
}
