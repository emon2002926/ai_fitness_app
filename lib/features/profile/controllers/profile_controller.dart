import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:ai_fitness_app/features/auth/views/sign_in_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_age_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_diet_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_goal_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_height_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../views/privacy_policy_screen.dart';
import '../views/support_legal_screen.dart';
import '../views/terms_conditions_screen.dart';
import '../widgets/edit_weight_screen.dart';

class ProfileController extends GetxController {
  // Observables – replace with real data from your API/storage
  final userName = 'User'.obs;
  final avatarUrl = ''.obs; // set to network URL when available
  final isPremium = true.obs;

  // Level / XP
  final level = 12.obs;
  final currentXp = 8450.obs;
  final maxXp = 12000.obs;

  // Stats
  final dayStreak = 14.obs;
  final workoutCount = 42.obs;
  final kgGained = 5.30.obs;

  // Personal details
  final currentWeight = '70 kg'.obs;
  final height = '169 cm'.obs;
  final age = '19 Years'.obs;
  final goal = 'Endurance'.obs;
  final diet = 'Vegetarian'.obs;

  double get xpProgress => currentXp.value / maxXp.value;

  void onNotificationPressed() {}

  void onAvatarPressed() {}

  void onPersonalDetailTap(String field) {}

  void onSupportAndLegal(BuildContext context) {
    AppNavigation.push(
      SupportLegalScreen(),
      context: context
    );
  }
  void onPrivacyPolicy(BuildContext context) {
    AppNavigation.push(
      PrivacyPolicyScreen(),
      context: context
    );
  }
  void onTermsAndConditions(BuildContext context ) {
    AppNavigation.pushAndClear(
       SignInScreen(),
    );
  }

  void currentWeightTap(BuildContext context) {
    AppNavigation.push(EditWeightScreen(), context: context);
  }
  void heightTap(BuildContext context) {
    AppNavigation.push(EditHeightScreen(), context: context);
  }
  void ageTap(BuildContext context) {
    AppNavigation.push(EditAgeScreen(), context: context);
  }
  void goalTap(BuildContext context) {
    AppNavigation.push(EditGoalScreen(), context: context);
  }
  void dietTap(BuildContext context) {
    AppNavigation.push(EditDietScreen(), context: context);
  }


}

