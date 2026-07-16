import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/onboarding_service.dart';


class GoalOption {
  final String emoji;
  final String label;

  const GoalOption({required this.emoji, required this.label});
}

class EditGoalController extends GetxController {
  final selectedGoal = 'Endurance'.obs;
  final isLoading    = false.obs;

  final List<GoalOption> goals = const [
    GoalOption(emoji: '🔥', label: 'Fat Loss'),
    GoalOption(emoji: '💪', label: 'Muscle Gain'),
    GoalOption(emoji: '🏃', label: 'Endurance'),
    GoalOption(emoji: '❤️', label: 'General Health'),
  ];

  void selectGoal(String goal) => selectedGoal.value = goal;

  Future<void> save(BuildContext context) async {
    isLoading.value = true;
    final success = await OnboardingService.patch({'primary_goal': selectedGoal.value});
    isLoading.value = false;
    if (success && context.mounted) Navigator.pop(context);
  }
}
class EditGoalScreen extends StatelessWidget {
  const EditGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EditGoalController>()
        ? Get.find<EditGoalController>()
        : Get.put(EditGoalController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(16)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: GestureDetector(
                onTap: () {Navigator.pop(context);},
                child: Container(
                  width: context.w(40),
                  height: context.w(40),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5A623),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
            ),
            SizedBox(height: context.h(40)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: AppText(
                data: "What's Your Primary Goal?",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: context.h(36)),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.goals.length,
                separatorBuilder: (_, _) => SizedBox(height: context.h(14)),
                itemBuilder: (context, index) {
                  final option = controller.goals[index];
                  return Obx(() => _SelectionCard(
                    emoji: option.emoji,
                    label: option.label,
                    isSelected: controller.selectedGoal.value == option.label,
                    onTap: () => controller.selectGoal(option.label),
                  ));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(24),
              ),
              child: Obx(() => AppButton(
                buttonText: 'SAVE',
                onPressed: (){controller.save(context);},
                fillColor: const Color(0xFFF5A623),
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                buttonHeight: 56,
                isLoading: controller.isLoading.value,
                loadingText: 'Saving...',
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: context.h(70),
        padding: EdgeInsets.symmetric(horizontal: context.w(16)),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFF5A623) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: context.sp(24))),
            SizedBox(width: context.w(14)),
            Expanded(
              child: AppText(
                data: label,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.w(24),
              height: context.w(24),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF5A623) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFF5A623) : Colors.white24,
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}