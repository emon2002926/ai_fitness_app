import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/views/sign_in_screen.dart';
import '../views/exercise_timer_screen.dart';

class WorkoutController extends GetxController {
  final isLoading      = true.obs;
  final dayStreak      = 0.obs;
  final exercisesCount = 0.obs;
  final kcalGained     = 0.0.obs;

  final days             = <Map<String, String>>[].obs;
  final selectedDayIndex = 0.obs;

  final workoutName      = ''.obs;
  final workoutFocus     = ''.obs;
  final workoutDuration  = 0.obs;
  final workoutExercises = 0.obs;
  final workoutXp        = 50.obs;
  final workoutImage     = 'assets/images/workout_thumb.png'.obs;

  final exercises  = <Map<String, dynamic>>[].obs;
  final _weeklyPlan = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkoutPlan();
  }

  Future<void> fetchWorkoutPlan() async {
    isLoading.value = true;
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

        final weekly = (plans[0]['weekly_plan'] as List)
            .cast<Map<String, dynamic>>();

        _weeklyPlan.value = weekly;

        days.value = weekly.map((day) {
          final dayName = (day['day'] as String).toLowerCase();
          return <String, String>{
            'day':     _dayLetter(dayName),
            'label':   _dayLabel(dayName),
            'dayName': day['day'] as String,
          };
        }).toList();

        exercisesCount.value = weekly.fold<int>(
          0, (sum, d) => sum + (d['exercises'] as List).length,
        );

        final todayIndex = _todayIndex(weekly);
        selectedDayIndex.value = todayIndex;
        _applyDay(todayIndex);
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

  void selectDay(int index) {
    selectedDayIndex.value = index;
    _applyDay(index);
  }

  void _applyDay(int index) {
    if (_weeklyPlan.isEmpty || index >= _weeklyPlan.length) return;

    final day    = _weeklyPlan[index];
    final rawExs = (day['exercises'] as List).cast<Map<String, dynamic>>();

    workoutName.value      = day['focus'] as String? ?? '';
    workoutFocus.value     = day['focus'] as String? ?? '';
    workoutExercises.value = rawExs.length;
    workoutDuration.value  = _sumDurations(rawExs);

    exercises.value = rawExs.map((e) => <String, dynamic>{
      'name':     e['name'] as String? ?? '',
      'sets':     e['sets'] as String? ?? 'N/A',
      'reps':     e['reps'] as String? ?? 'N/A',
      'duration': e['duration'] as String? ?? 'N/A',
      'image':    e['image'] as String? ?? '',
      'done':     false,
    }).toList();
  }

  void onStartExercise(BuildContext context, int exerciseIndex) {
    if (exerciseIndex >= exercises.length) return;
    final exercise = exercises[exerciseIndex];

    AppNavigation.push(
      ExerciseTimerScreen(
        exerciseName:    exercise['name'] as String,
        sets:            int.tryParse(exercise['sets'].toString()) ?? 3,
        reps:            exercise['reps'] as String? ?? '',
        durationSeconds: _parseDurationSeconds(exercise['duration'].toString()),
        exerciseImage:   exercise['image'] as String? ?? '',
        allExercises:    exercises.toList(),
        startIndex:      exerciseIndex,
      ),
      context: context,
    );
  }

  void onStartWorkout(BuildContext context) => onStartExercise(context, 0);

  int _todayIndex(List<Map<String, dynamic>> weekly) {
    final todayName = _fullDayName(DateTime.now().weekday);
    final idx = weekly.indexWhere(
          (d) => (d['day'] as String).toLowerCase() == todayName,
    );
    return idx == -1 ? 0 : idx;
  }

  String _fullDayName(int weekday) {
    const names = [
      'monday', 'tuesday', 'wednesday',
      'thursday', 'friday', 'saturday', 'sunday',
    ];
    return names[weekday - 1];
  }

  String _dayLabel(String dayName) {
    return dayName.length >= 3
        ? dayName.substring(0, 3).toUpperCase()
        : dayName.toUpperCase();
  }

  String _dayLetter(String dayName) {
    const map = <String, String>{
      'monday':    'Mo',
      'tuesday':   'Tu',
      'wednesday': 'We',
      'thursday':  'Th',
      'friday':    'Fr',
      'saturday':  'Sa',
      'sunday':    'Su',
    };
    return map[dayName] ?? dayName.substring(0, 2);
  }

  int _sumDurations(List<Map<String, dynamic>> exs) {
    int total = 0;
    for (final e in exs) {
      final match = RegExp(r'\d+').firstMatch(e['duration']?.toString() ?? '');
      if (match != null) total += int.parse(match.group(0)!);
    }
    return total > 0 ? total : 30;
  }

  int _parseDurationSeconds(String raw) {
    final match = RegExp(
      r'(\d+)\s*(minute|min|second|sec)',
      caseSensitive: false,
    ).firstMatch(raw);
    if (match == null) return 139;
    final value = int.parse(match.group(1)!);
    final unit  = match.group(2)!.toLowerCase();
    return unit.startsWith('s') ? value : value * 60;
  }
}