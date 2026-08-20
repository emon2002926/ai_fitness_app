import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../../base_screen/views/base_page.dart';
import '../../../core/controllers/mascot_controller.dart';

class UserInfoController extends GetxController {
  final pageController = PageController();
  final currentStep = 0.obs;

  static const int totalSteps = 9;


  // Step 0 - Age
  final selectedAge = 19.obs;

  // Step 1 - Weight
  final weightUnit = 'KG'.obs;
  final weightController = TextEditingController(text: '62');

  // Step 2 - Gender
  final selectedGender = ''.obs;
  final genders = [
    {'emoji': '👩', 'label': 'Female'},
    {'emoji': '👨', 'label': 'Male'},
    {'emoji': '🧑', 'label': 'Other'},
  ];

  // Step 3 - Height
  final heightUnit = 'Cm'.obs;
  final heightController = TextEditingController(text: '172');

  // Step 4 - Diet
  final selectedDiet = ''.obs;
  final diets = [
    {'emoji': '🍽️', 'label': 'No Preference'},
    {'emoji': '🥦', 'label': 'Vegetarian'},
    {'emoji': '🌱', 'label': 'Vegan'},
    {'emoji': '🌾', 'label': 'Gluten-Free'},
  ];

  // Step 5 - Primary Goal
  final selectedGoal = ''.obs;
  final goals = [
    {'emoji': '🔥', 'label': 'Fat Loss'},
    {'emoji': '💪', 'label': 'Muscle Gain'},
    {'emoji': '🏃', 'label': 'Endurance'},
    {'emoji': '❤️', 'label': 'General Health'},
  ];

  // Step 6 - Activity Level
  final selectedActivity = ''.obs;
  final activities = [
    {'emoji': '🪑', 'label': 'Sedentary'},
    {'emoji': '🚶', 'label': 'Light'},
    {'emoji': '🏃', 'label': 'Moderate'},
    {'emoji': '💪', 'label': 'Active'},
    {'emoji': '🔥', 'label': 'Very Active'},
  ];

  // Step 7 - Workout Time
  final selectedWorkoutTime = ''.obs;
  final workoutTimes = [
    {'emoji': '🌅', 'label': 'Morning'},
    {'emoji': '⛅', 'label': 'Afternoon'},
    {'emoji': '🌆', 'label': 'Evening'},
    {'emoji': '🔄', 'label': 'Flexible'},
  ];

  // Step 8 - Mascot
  final selectedMascot = ''.obs;
  final selectedMascotIndex = 0.obs;
  final mascots = [
    {'image': 'assets/images/mascot_lion.png',     'label': 'Leo the Lion','name':'lion'},
    {'image': 'assets/images/mascot_tiger.png',    'label': 'Tory the Tiger','name':'tiger'},
    {'image': 'assets/images/mascot_dog.png',      'label': 'Goldie the Pup','name':'dog'},
    {'image': 'assets/images/mascot_elephant.png', 'label': 'Ellie the Elephant','name':'elephant'},
    {'image': 'assets/images/mascot_panda.png',    'label': 'Panda the Panda','name':'panda'},
  ];

  double get progress => (currentStep.value + 1) / totalSteps;

  void onPageChanged(int index) => currentStep.value = index;

  void nextStep() {
    if (!_validateCurrentStep()) return;
    if (currentStep.value < totalSteps - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _submitAndNavigate();
    }
  }

  void goBack() {
    if (currentStep.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 1:
        if (double.tryParse(weightController.text.trim()) == null) {
          CustomSnackBar.error('Please enter a valid weight.');
          return false;
        }
      case 2:
        if (selectedGender.value.isEmpty) {
          CustomSnackBar.error('Please select your gender.');
          return false;
        }
      case 3:
        if (double.tryParse(heightController.text.trim()) == null) {
          CustomSnackBar.error('Please enter a valid height.');
          return false;
        }
      case 4:
        if (selectedDiet.value.isEmpty) {
          CustomSnackBar.error('Please select a diet preference.');
          return false;
        }
      case 5:
        if (selectedGoal.value.isEmpty) {
          CustomSnackBar.error('Please select your primary goal.');
          return false;
        }
      case 6:
        if (selectedActivity.value.isEmpty) {
          CustomSnackBar.error('Please select your activity level.');
          return false;
        }
      case 7:
        if (selectedWorkoutTime.value.isEmpty) {
          CustomSnackBar.error('Please select your workout time.');
          return false;
        }
      // case 8:
      //   if (selectedMascot.value.isEmpty) {
      //     CustomSnackBar.error('Please choose your mascot.');
      //     return false;
      //   }
    }
    return true;
  }

  Future<void> _submitAndNavigate() async {
    const endpoint = AppConstant.onboardingEndpoint;
    int index = selectedMascotIndex.value;
    String mascot = mascots[index]['name']!;
    final body = {
      'age': selectedAge.value,
      'weight': weightController.text.trim(),
      'height': heightController.text.trim(),
      'gender': selectedGender.value,
      'diet': selectedDiet.value,
      'primary_goal': selectedGoal.value,
      'workout_time': selectedWorkoutTime.value,
      'workout_buddy': selectedMascotIndex.value,
      'avatar_species': mascot,
    };

    try {
      AppLog.request(endpoint, body: body);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${StorageService.accessToken}',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        AppLog.response(endpoint, data);

        // Fire off plan generation in the background
        _triggerPlanGeneration();
        
        // Eagerly show the generating UI on the home screen
        MascotController.to.isPlanGenerating.value = true;

        AppNavigation.pushAndClear(const BasePage());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        final message = data['detail'] ?? data['message'] ?? 'Failed to save onboarding data';
        CustomSnackBar.error(message);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');
    }
  }
  
  Future<void> _triggerPlanGeneration() async {
    const generateEndpoint = '${AppConstant.baseUrl}/api/v1/service/onboarding/generate-plan/';
    try {
      await http.post(
        Uri.parse(generateEndpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
        },
      );
    } catch (e) {
      AppLog.error(generateEndpoint, 'Background plan generation failed: $e');
    }
  }
  int _calculateCalories() => 2150;
  int _calculateProtein() => 180;

  @override
  void onClose() {
    pageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }
}