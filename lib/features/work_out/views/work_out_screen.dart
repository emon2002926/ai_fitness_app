import 'package:flutter/material.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/workout_controller.dart';
import 'package:get/get.dart';
class WorkOutScreen extends StatelessWidget {
  const WorkOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkoutController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Workouts',
        showNotification: true,
        showBackButton: false,
        avatarUrl: 'assets/images/avatar.png',
        onNotificationPressed: () {},
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5A623)),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(20)),
                _StatsRow(controller: controller),
                SizedBox(height: context.h(20)),
                _WeekDayPicker(controller: controller),
                SizedBox(height: context.h(20)),
                _WorkoutCard(controller: controller),
                SizedBox(height: context.h(40)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _WorkoutStatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _WorkoutStatCard({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.h(16),
        horizontal: context.w(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: context.sp(22))),
          SizedBox(height: context.h(8)),
          AppText(
            data: value,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          SizedBox(height: context.h(4)),
          AppText(
            data: label,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white38,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final WorkoutController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _WorkoutStatCard(
            emoji: '🔥',
            value: '${controller.dayStreak.value}',
            label: 'Day Streak',
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: _WorkoutStatCard(
            emoji: '🏋️',
            value: '${controller.exercisesCount.value}',
            label: 'Exercises',
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: _WorkoutStatCard(
            emoji: '🏆',
            value: '+${controller.kcalGained.value.toStringAsFixed(2)}',
            label: 'Kcal Gained',
          ),
        ),
      ],
    ));
  }
}

class _WeekDayPicker extends StatelessWidget {
  final WorkoutController controller;
  const _WeekDayPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      height: context.h(72),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.days.length,
        separatorBuilder: (_, __) => SizedBox(width: context.w(10)),
        itemBuilder: (context, index) {
          final day = controller.days[index];
          final isSelected = controller.selectedDayIndex.value == index;

          return GestureDetector(
            onTap: () => controller.selectDay(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.w(60),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF5A623)
                    : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(context.w(14)),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white70,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data: day['day'] as String,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  SizedBox(height: context.h(2)),
                  AppText(
                    data: day['label'] as String,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Colors.white70 : Colors.white38,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutController controller;
  const _WorkoutCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    controller.workoutImage.value,
                    width: context.w(56),
                    height: context.w(56),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: context.w(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data: controller.workoutName.value,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      SizedBox(height: context.h(4)),
                      AppText(
                        data:
                        '${controller.workoutDuration.value} min • ${controller.workoutExercises.value} Exercises • ${controller.workoutXp.value} Xp',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFF5A623),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white70, height: 1),
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'Exercises',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                SizedBox(height: context.h(12)),
                ...controller.exercises.map((exercise) {
                  final isDone = exercise['done'] as bool;
                  final imageUrl = exercise['image'] as String;

                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: context.w(52),
                          height: context.w(52),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius:
                            BorderRadius.circular(context.w(10)),
                            border: Border.all(color: Colors.white12),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.fitness_center,
                              color: Colors.white38,
                            ),
                          )
                              : const Icon(
                            Icons.fitness_center,
                            color: Colors.white38,
                          ),
                        ),
                        SizedBox(width: context.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: exercise['name'] as String,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isDone ? Colors.white24 : Colors.white,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: Colors.white24,
                              ),
                              SizedBox(height: context.h(4)),
                              _ExerciseMeta(exercise: exercise),
                            ],
                          ),
                        ),
                        SizedBox(width: context.w(8)),
                        isDone
                            ? Container(
                          width: context.w(24),
                          height: context.w(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        )
                            : Container(
                          width: context.w(24),
                          height: context.w(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: context.h(8)),
                AppButton(
                  buttonText: 'START EXERCISE',
                  onPressed: () => controller.onStartWorkout(context),
                  fillColor: const Color(0xFFF5A623),
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 10,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class _ExerciseMeta extends StatelessWidget {
  final Map<String, dynamic> exercise;
  const _ExerciseMeta({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final chips = <String>[];
    if (exercise['sets'] != 'N/A') chips.add('${exercise['sets']} sets');
    if (exercise['reps'] != 'N/A') chips.add('${exercise['reps']} reps');
    if (exercise['duration'] != 'N/A') chips.add(exercise['duration'] as String);

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: context.w(6),
      runSpacing: context.h(4),
      children: chips
          .map((chip) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(8),
          vertical: context.h(2),
        ),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(context.w(20)),
        ),
        child: AppText(
          data: chip,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFF5A623),
        ),
      ))
          .toList(),
    );
  }
}