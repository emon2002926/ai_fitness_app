
import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/text/app_text.dart';
class WorkoutPreviewDialog extends StatelessWidget {
  final String workoutName;
  final int duration;
  final int exerciseCount;
  final int xp;
  final List<WorkoutExercise> exercises;
  final VoidCallback onStart;

  const WorkoutPreviewDialog({
    super.key,
    required this.workoutName,
    required this.duration,
    required this.exerciseCount,
    required this.xp,
    required this.exercises,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(20)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.w(20)),
        side: const BorderSide(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Row(
              children: [
                Container(
                  width: context.w(72),
                  height: context.w(72),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AppAssertImage.instance.workoutBanner),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: context.w(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data: workoutName,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      SizedBox(height: context.h(6)),
                      AppText(
                        data: '$duration min • $exerciseCount Exercises • $xp Xp',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF5A623),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),

          // Exercise list
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'Exercises',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                SizedBox(height: context.h(12)),
                ...exercises.map((e) => Padding(
                  padding: EdgeInsets.only(bottom: context.h(14)),
                  child: Row(
                    children: [
                      Container(
                        width: context.w(6),
                        height: context.w(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: e.done ? Colors.white24 : Colors.white70,
                        ),
                      ),
                      SizedBox(width: context.w(12)),
                      AppText(
                        data: e.name,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: e.done ? Colors.white38 : Colors.white,
                        // assumes AppText supports decoration; if not, see note below
                        decoration: e.done ? TextDecoration.lineThrough : null,
                      ),
                    ],
                  ),
                )),
                SizedBox(height: context.h(8)),
                AppButton(
                  buttonText: 'START EXERCISE',
                  onPressed: onStart,
                  fillColor: const Color(0xFFF5A623),
                  textColor: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  buttonWidth: context.widthPercentage(100),
                  buttonHeight: 54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutExercise {
  final String name;
  final bool done;
  const WorkoutExercise(this.name, {this.done = false});
}