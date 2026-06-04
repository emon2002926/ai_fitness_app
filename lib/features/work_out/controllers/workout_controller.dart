import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/app_navigation.dart';
import '../../base_screen/controllers/base_controller.dart';
import '../views/exercise_timer_screen.dart';

class WorkoutController extends GetxController {
  final dayStreak = 14.obs;
  final exercisesCount = 42.obs;
  final kcalGained = 5.30.obs;

  final selectedDayIndex = 2.obs;

  final days = <Map<String, String>>[
    {'day': '2', 'label': 'WED'},
    {'day': '3', 'label': 'THU'},
    {'day': '4', 'label': 'FRI'},
    {'day': '5', 'label': 'SAT'},
    {'day': '6', 'label': 'SUN'},
    {'day': '7', 'label': 'MON'},
    {'day': '8', 'label': 'TUE'},
  ];

  final workoutName = 'Full Body Warm Up'.obs;
  final workoutDuration = 45.obs;
  final workoutExercises = 6.obs;
  final workoutXp = 50.obs;
  final workoutImage = 'assets/images/workout_thumb.png'.obs;

  final exercises = <Map<String, dynamic>>[
    {'name': 'Jumping Jacks', 'done': true},
    {'name': 'Arm Circles', 'done': false},
    {'name': 'Leg Swings', 'done': false},
    {'name': 'Bodyweight Squats', 'done': false},
    {'name': 'Hip Circles', 'done': false},
    {'name': 'Torso Twists', 'done': false},
  ];

  void selectDay(int index) => selectedDayIndex.value = index;

  void onStartExercise(BuildContext context, int exerciseIndex) {
    final exercise = exercises[exerciseIndex];
    AppNavigation.push(
      ExerciseTimerScreen(
        exerciseName: exercise['name'] as String,
        sets: 3,
        reps: 20,
        durationSeconds: 139,
        exerciseImage: 'assets/images/exercise_image.png',
      ),
      context: context,
    );
  }

  void onStartWorkout(BuildContext context) => onStartExercise(context, 0);
}