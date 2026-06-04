import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../profile/views/profile_screen.dart';

class HomeController extends GetxController {
  // User info
  final userName = 'Donald'.obs;
  final avatarUrl = 'assets/images/avatar.png'.obs;

  // Streak badge
  final streakCount = 0.obs;

  // Level card
  final level = 12.obs;
  final currentXp = 8450.obs;
  final maxXp = 12000.obs;

  double get xpProgress =>
      (currentXp.value / maxXp.value).clamp(0.0, 1.0);

  // Stats
  final workoutCount = 24.obs;
  final goalProgress = 9.obs;

  // Today's plan
  final todayWorkoutName = 'Upper Body Strength'.obs;
  final workoutDuration = 45.obs;
  final exerciseCount = 6.obs;
  final workoutXp = 50.obs;

  // Calories
  final kcalLeft = 1522.obs;
  final kcalTotal = 2150.obs;

  // Macros
  final proteinLeft = 66.obs;
  final carbsLeft = 22.obs;
  final carbsGLeft = 114.obs;
  final fatLeft = 11.obs;
  final fatGLeft = 114.obs;

  void onNotificationTap() {
    // TODO: navigate to notifications
  }

  void onAvatarTap(BuildContext cotext ) {

    AppNavigation.push( ProfileScreen(),context: cotext);
  }

  void onStartWorkout() {
    // TODO: navigate to workout detail
  }
}