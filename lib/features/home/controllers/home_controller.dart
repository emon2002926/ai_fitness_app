import 'dart:convert';
import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:ai_fitness_app/features/auth/views/sign_in_screen.dart';
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

  final todayWorkoutName = ''.obs;
  final todayFocus = ''.obs;
  final workoutDuration = 0.obs;
  final exerciseCount = 0.obs;
  final workoutXp = 50.obs;

  final kcalLeft = 1522.obs;
  final kcalTotal = 2150.obs;
  final proteinLeft = 66.obs;
  final carbsLeft = 22.obs;
  final carbsGLeft = 114.obs;
  final fatLeft = 11.obs;
  final fatGLeft = 114.obs;

  final todayExercises = <WorkoutExercise>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      fetchHomeData(),
      fetchTodayWorkoutPlan(),
    ]);
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
          'accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final d = data['data'];
        userName.value     = d['full_name'] ?? '';
        currentXp.value    = d['total_xp'] ?? 0;
        maxXp.value        = d['target_xp'] ?? 0;
        level.value        = d['current_level'] ?? 0;
        streakCount.value  = d['streak'] ?? 0;
        workoutCount.value = d['count_of_workouts'] ?? 0;
        goalProgress.value = d['goal_progress_percentage'] ?? 0;
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
    }
  }


  Future<void> fetchTodayWorkoutPlan() async {
    const endpoint = AppConstant.workoutPlanEndpoint;


    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final plans = data['data'] as List;
        if (plans.isEmpty) return;

        final weeklyPlan = plans[0]['weekly_plan'] as List;
        final todayName  = _todayDayName();

        final todayPlan = weeklyPlan.firstWhereOrNull(
              (day) => (day['day'] as String).toLowerCase() == todayName,
        );

        if (todayPlan == null) return;

        final exercises = todayPlan['exercises'] as List;

        todayWorkoutName.value = todayPlan['focus'] ?? '';
        todayFocus.value       = todayPlan['focus'] ?? '';
        exerciseCount.value    = exercises.length;
        workoutDuration.value  = _sumDurations(exercises);

        todayExercises.value = exercises.map((e) {
          return WorkoutExercise(
            e['name'] ?? '',
            sets:     e['sets'] ?? 'N/A',
            reps:     e['reps'] ?? 'N/A',
            duration: e['duration'] ?? 'N/A',
            imageUrl: e['image'] ?? '',
          );
        }).toList();
      } else if (response.statusCode == 401) {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    }
  }


  String _todayDayName() {
    const days = [
      'monday', 'tuesday', 'wednesday',
      'thursday', 'friday', 'saturday', 'sunday',
    ];
    return days[DateTime.now().weekday - 1];
  }

  int _sumDurations(List exercises) {
    int total = 0;
    for (final e in exercises) {
      final dur   = e['duration'] as String? ?? '';
      final match = RegExp(r'\d+').firstMatch(dur);
      if (match != null) total += int.parse(match.group(0)!);
    }
    return total > 0 ? total : 30;
  }


  void onNotificationTap() {}

  void onAvatarTap(BuildContext context) {
    AppNavigation.push(ProfileScreen(), context: context);
  }

  void onStartWorkout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => WorkoutPreviewDialog(
        workoutName:   todayWorkoutName.value,
        duration:      workoutDuration.value,
        exerciseCount: exerciseCount.value,
        xp:            workoutXp.value,
        exercises:     todayExercises,
        onStart: () {
          Navigator.of(dialogContext).pop();
          Get.find<BaseController>().onTabSelected(1);
        },
      ),
    );
  }
}