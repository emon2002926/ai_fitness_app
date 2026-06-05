import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base_screen/controllers/base_controller.dart';
import '../../profile/views/profile_screen.dart';
import '../../work_out/views/work_out_screen.dart';
import '../widgets/workout_preview_dialog.dart';

class HomeController extends GetxController {
  final userName = 'Donald'.obs;
  final avatarUrl = 'assets/images/avatar.png'.obs;

  final streakCount = 0.obs;

  final level = 12.obs;
  final currentXp = 8450.obs;
  final maxXp = 12000.obs;

  double get xpProgress =>
      (currentXp.value / maxXp.value).clamp(0.0, 1.0);

  final workoutCount = 24.obs;
  final goalProgress = 9.obs;

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



  final todayExercises = <WorkoutExercise>[
    const WorkoutExercise('Jumping Jacks', done: true),
    const WorkoutExercise('Arm Circles'),
    const WorkoutExercise('Leg Swings'),
    const WorkoutExercise('Bodyweight Squats'),
    const WorkoutExercise('Hip Circles'),
    const WorkoutExercise('Torso Twists'),
  ].obs;

  void onNotificationTap() {
    // TODO: navigate to notifications
  }

  void onAvatarTap(BuildContext cotext ) {

    AppNavigation.push( ProfileScreen(),context: cotext);
  }
  void onStartWorkout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => WorkoutPreviewDialog(
        workoutName: todayWorkoutName.value,
        duration: workoutDuration.value,
        exerciseCount: exerciseCount.value,
        xp: workoutXp.value,
        exercises: todayExercises,
        onStart: () {
          Navigator.of(dialogContext).pop();
          Get.find<BaseController>().onTabSelected(1);
        },
      ),
    );
  }
}
