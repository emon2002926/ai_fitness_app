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
// app_constant.dart — add this endpoint
// static const String workoutPlanEndpoint = 'https://lexiapi.dsrt321.online/api/v1/service/onboarding/workout-plan/list/';


class WorkoutController extends GetxController {
  // ── Stats (static for now) ─────────────────────────────────────────────────
  final dayStreak      = 14.obs;
  final exercisesCount = 42.obs;
  final kcalGained     = 5.30.obs;

  // ── Loading ────────────────────────────────────────────────────────────────
  final isLoading = false.obs;

  // ── Day picker ─────────────────────────────────────────────────────────────
  // Each map: {'date': '11', 'label': 'TUE', 'weekday': 'Tuesday'}
  final days = <Map<String, String>>[].obs;
  final selectedDayIndex = 0.obs;

  // ── Workout card ───────────────────────────────────────────────────────────
  final workoutName      = ''.obs;
  final workoutDuration  = ''.obs;
  final workoutExercises = 0.obs;
  final workoutXp        = 50.obs;  // static for now
  final workoutImage     = 'assets/images/workout_thumb.png'.obs;

  // ── Exercise list ──────────────────────────────────────────────────────────
  final exercises = <Map<String, dynamic>>[].obs;

  // ── Raw weekly plan ────────────────────────────────────────────────────────
  final _weeklyPlan = <Map<String, dynamic>>[];

  // ── Day name → weekday number (DateTime.weekday: Mon=1 … Sun=7) ───────────
  static const _dayToWeekday = {
    'Monday': 1, 'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4,
    'Friday': 5, 'Saturday': 6, 'Sunday': 7,
  };

  @override
  void onInit() {
    super.onInit();
    fetchWorkoutPlan();
  }

  // ── API ────────────────────────────────────────────────────────────────────
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

        final List<dynamic> plans = data['data'] ?? [];
        if (plans.isNotEmpty) {
          final plan = plans.first as Map<String, dynamic>;
          _weeklyPlan
            ..clear()
            ..addAll(List<Map<String, dynamic>>.from(plan['weekly_plan'] ?? []));

          _buildDayPicker();
        }
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

  // ── Build day picker from API weekly_plan ──────────────────────────────────
  // Strategy: find the Monday of the current week, then map each API day
  // to its real calendar date.
  void _buildDayPicker() {
    final today    = DateTime.now();
    // Monday of the current week
    final monday   = today.subtract(Duration(days: today.weekday - 1));

    final builtDays = <Map<String, String>>[];

    for (final dayPlan in _weeklyPlan) {
      final dayName   = dayPlan['day'] as String;           // "Tuesday"
      final weekdayNum = _dayToWeekday[dayName] ?? 1;       // 2
      final date      = monday.add(Duration(days: weekdayNum - 1));

      builtDays.add({
        'date':    date.day.toString(),                      // "15"
        'label':   dayName.substring(0, 3).toUpperCase(),   // "TUE"
        'weekday': dayName,                                  // "Tuesday"
      });
    }

    days.value = builtDays;

    // Default select today; fallback to first
    final todayWeekdayName = _weekdayNumberToName(today.weekday);
    final todayIdx = builtDays.indexWhere(
          (d) => d['weekday'] == todayWeekdayName,
    );
    selectedDayIndex.value = todayIdx >= 0 ? todayIdx : 0;
    _loadDayWorkout(selectedDayIndex.value);
  }

  String _weekdayNumberToName(int weekday) {
    const names = [
      '', 'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    return names[weekday];
  }

  // ── Select a day chip ──────────────────────────────────────────────────────
  void selectDay(int index) {
    selectedDayIndex.value = index;
    _loadDayWorkout(index);
  }

  // ── Populate workout card for the given index ──────────────────────────────
  void _loadDayWorkout(int index) {
    if (_weeklyPlan.isEmpty || index >= _weeklyPlan.length) return;

    final day         = _weeklyPlan[index];
    final rawExercises = List<Map<String, dynamic>>.from(day['exercises'] ?? []);

    workoutName.value      = day['focus'] as String? ?? 'Workout';
    workoutExercises.value = rawExercises.length;

    // Use duration of first exercise that isn't "N/A"
    final firstDuration = rawExercises
        .map((e) => e['duration'] as String? ?? 'N/A')
        .firstWhere((d) => d != 'N/A', orElse: () => 'N/A');
    workoutDuration.value = firstDuration;

    // Use first non-empty image as card thumbnail
    final firstImage = rawExercises
        .map((e) => e['image'] as String? ?? '')
        .firstWhere((img) => img.isNotEmpty, orElse: () => '');
    workoutImage.value = firstImage.isNotEmpty
        ? firstImage
        : 'assets/images/workout_thumb.png';

    exercises.value = rawExercises
        .map((e) => {
      'name':     e['name']     as String? ?? '',
      'sets':     e['sets']     as String? ?? '',
      'reps':     e['reps']     as String? ?? '',
      'duration': e['duration'] as String? ?? '',
      'image':    e['image']    as String? ?? '',
      'done':     false,
    })
        .toList();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  void onStartExercise(BuildContext context, int exerciseIndex) {
    if (exerciseIndex >= exercises.length) return;
    final exercise = exercises[exerciseIndex];

    final sets = int.tryParse(exercise['sets'] as String? ?? '') ?? 3;
    final reps = int.tryParse(exercise['reps'] as String? ?? '') ?? 10;
    final durationSec = _parseDurationToSeconds(exercise['duration'] as String? ?? '');

    final img = exercise['image'] as String? ?? '';

    AppNavigation.push(
      ExerciseTimerScreen(
        exerciseName:    exercise['name'] as String,
        sets:            sets,
        reps:            reps,
        durationSeconds: durationSec,
        exerciseImage:   img.isNotEmpty ? img : 'assets/images/exercise_image.png',
      ),
      context: context,
    );
  }

  void onStartWorkout(BuildContext context) => onStartExercise(context, 0);

  int _parseDurationToSeconds(String duration) {
    final lower  = duration.toLowerCase();
    final number = int.tryParse(lower.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (lower.contains('minute')) return number * 60;
    if (lower.contains('second')) return number;
    return 139;
  }
}