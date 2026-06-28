import 'dart:convert';
import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/storage_service.dart';
import '../../base_screen/controllers/base_controller.dart';
import '../../profile/views/profile_screen.dart';
import '../widgets/workout_preview_dialog.dart';

class HomeController extends GetxController {
  final isLoading = true.obs;

  final userName = ''.obs;
  final avatarUrl = 'assets/images/avatar.png'.obs;

  final streakCount = 0.obs;
  final level = 0.obs;
  final currentXp = 0.obs;
  final maxXp = 0.obs;
  final workoutCount = 0.obs;
  final goalProgress = 0.obs;

  double get xpProgress => maxXp.value == 0
      ? 0.0
      : (currentXp.value / maxXp.value).clamp(0.0, 1.0);

  // Static/local data (not from this API)
  final todayWorkoutName = 'Upper Body Strength'.obs;
  final workoutDuration = 45.obs;
  final exerciseCount = 6.obs;
  final workoutXp = 50.obs;

  final kcalLeft = 1522.obs;
  final kcalTotal = 2150.obs;
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

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    const endpoint = AppConstant.homeEndpoint;

    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final d = data['data'];
        userName.value       = d['full_name'] ?? '';
        currentXp.value      = d['total_xp'] ?? 0;
        maxXp.value          = d['target_xp'] ?? 0;
        level.value          = d['current_level'] ?? 0;
        streakCount.value    = d['streak'] ?? 0;
        workoutCount.value   = d['count_of_workouts'] ?? 0;
        goalProgress.value   = d['goal_progress_percentage'] ?? 0;
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onNotificationTap() {}

  void onAvatarTap(BuildContext context) {
    AppNavigation.push(ProfileScreen(), context: context);
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