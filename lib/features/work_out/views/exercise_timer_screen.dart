import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/exercise_timer_controller.dart';

class ExerciseTimerScreen extends StatelessWidget {
  final String exerciseName;
  final int sets;
  final String reps;
  final int durationSeconds;
  final String exerciseImage;
  final List<Map<String, dynamic>> allExercises;
  final int startIndex;

  const ExerciseTimerScreen({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.durationSeconds,
    required this.exerciseImage,
    required this.allExercises,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExerciseTimerController(
      exerciseName:    exerciseName,
      sets:            sets,
      reps:            reps,
      durationSeconds: durationSeconds,
      exerciseImage:   exerciseImage,
      allExercises:    allExercises,
      startIndex:      startIndex,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Workouts',
        showNotification: true,
        avatarUrl: 'assets/images/avatar.png',
        onNotificationPressed: () {},
      ),
      body: SafeArea(
        child: Obx(() => Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.h(16)),

              // Exercise counter
              AppText(
                data:
                'Exercise ${controller.currentIndex.value + 1} of ${controller.allExercises.length}',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white38,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.h(8)),

              AppText(
                data: controller.currentName.value,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.h(12)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PillBadge(
                    icon: Icons.fitness_center_rounded,
                    label: '${controller.currentSets.value} Sets',
                    isGold: false,
                  ),
                  if (controller.currentReps.value.isNotEmpty) ...[
                    SizedBox(width: context.w(10)),
                    _PillBadge(
                      icon: Icons.play_arrow_rounded,
                      label: '${controller.currentReps.value} Reps',
                      isGold: true,
                    ),
                  ],
                ],
              ),

              SizedBox(height: context.h(24)),

              // Exercise image
              Container(
                width: context.w(240),
                height: context.w(240),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child: controller.currentImage.value.startsWith('http')
                    ? Image.network(
                  controller.currentImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.fitness_center,
                    color: Colors.white38,
                    size: 60,
                  ),
                )
                    : Image.asset(
                  controller.currentImage.value.isNotEmpty
                      ? controller.currentImage.value
                      : 'assets/images/exercise_image.png',
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: context.h(24)),

              // Timer
              AppText(
                data: controller.formattedTime,
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),

              SizedBox(height: context.h(8)),

              // Set progress
              _SetProgressRow(controller: controller),

              const Spacer(),

              // Restart / Pause / Complete set
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonText: 'Restart',
                      onPressed: controller.restart,
                      fillColor: Colors.transparent,
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      borderColor: const Color(0xFFF5A623),
                      borderWidth: 1.5,
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: AppButton(
                      buttonText:
                      controller.isRunning.value ? 'Pause' : 'Resume',
                      onPressed: controller.togglePause,
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(12)),

              // Complete set / next exercise
              Row(
                children: [
                  if (!controller.isFirstExercise)
                    Expanded(
                      child: AppButton(
                        buttonText: 'Previous',
                        onPressed: controller.previousExercise,
                        fillColor: Colors.transparent,
                        textColor: Colors.white38,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        borderColor: Colors.white12,
                        borderWidth: 1,
                      ),
                    ),
                  if (!controller.isFirstExercise) SizedBox(width: context.w(12)),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      buttonText: controller.completedSets.value >=
                          controller.currentSets.value
                          ? controller.isLastExercise
                          ? 'Finish Workout'
                          : 'Next Exercise'
                          : 'Complete Set (${controller.completedSets.value}/${controller.currentSets.value})',
                      onPressed: () {
                        if (controller.completedSets.value >=
                            controller.currentSets.value) {
                          if (controller.isLastExercise) {
                            AppNavigation.pop(context);
                          } else {
                            controller.nextExercise();
                          }
                        } else {
                          controller.completeSet();
                        }
                      },
                      fillColor: controller.completedSets.value >=
                          controller.currentSets.value
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(32)),
            ],
          ),
        )),
      ),
    );
  }
}

class _SetProgressRow extends StatelessWidget {
  final ExerciseTimerController controller;
  const _SetProgressRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.currentSets.value, (i) {
        final done = i < controller.completedSets.value;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(4)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: context.w(28),
            height: context.h(6),
            decoration: BoxDecoration(
              color: done ? const Color(0xFF4CAF50) : Colors.white12,
              borderRadius: BorderRadius.circular(context.w(4)),
            ),
          ),
        );
      }),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isGold;

  const _PillBadge({
    required this.icon,
    required this.label,
    required this.isGold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(10),
      ),
      decoration: BoxDecoration(
        color: isGold ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(context.w(30)),
        border: Border.all(
          color: isGold ? Colors.white : Colors.white38,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: context.sp(16),
            color: isGold ? const Color(0xFFF5A623) : Colors.white,
          ),
          SizedBox(width: context.w(6)),
          AppText(
            data: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isGold ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}