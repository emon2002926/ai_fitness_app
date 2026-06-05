import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/exercise_timer_controller.dart';

class ExerciseTimerScreen extends StatelessWidget {
  final String exerciseName;
  final int sets;
  final int reps;
  final int durationSeconds;
  final String exerciseImage;

  const ExerciseTimerScreen({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.durationSeconds,
    required this.exerciseImage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExerciseTimerController(
      exerciseName: exerciseName,
      sets: sets,
      reps: reps,
      durationSeconds: durationSeconds,
      exerciseImage: exerciseImage,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.h(24)),

              AppText(
                data: exerciseName,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.h(16)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PillBadge(
                    icon: Icons.fitness_center_rounded,
                    label: '$sets Sets',
                    isGold: false,
                  ),
                  SizedBox(width: context.w(12)),
                  _PillBadge(
                    icon: Icons.play_arrow_rounded,
                    label: '$reps Reps',
                    isGold: true,
                  ),
                ],
              ),

              SizedBox(height: context.h(32)),

              Container(
                width: context.w(260),
                height: context.w(260),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  exerciseImage,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: context.h(40)),

              Obx(() => AppText(
                data: controller.formattedTime,
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              )),

              const Spacer(),

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
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: Obx(() => AppButton(
                      buttonText: controller.isRunning.value ? 'Pause' : 'Resume',
                      onPressed: controller.togglePause,
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                ],
              ),

              SizedBox(height: context.h(40)),
            ],
          ),
        ),
      ),
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