import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/userInfo_controller.dart';

class UserInfoScreen extends GetView<UserInfoController> {

  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserInfoController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
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
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(context.w(4)),
                      child: LinearProgressIndicator(
                        value: controller.progress,
                        minHeight: context.h(4),
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFF5A623)),
                      ),
                    )),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _AgeStep(),
                  _WeightStep(),
                  _GenderStep(),
                  _HeightStep(),
                  _DietStep(),
                  _GoalStep(),
                  _ActivityStep(),
                  _WorkoutTimeStep(),
                  _MascotStep(), // new
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(24),
                context.h(8),
                context.w(24),
                context.h(32),
              ),
              child: AppButton(
                buttonText: 'CONTINUE',
                onPressed: controller.nextStep,
                fillColor: const Color(0xFFF5A623),
                textColor: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _StepTitle extends StatelessWidget {
  final String title;
  const _StepTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: AppText(
        data: title,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionTile({
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
        margin: EdgeInsets.only(bottom: context.h(12)),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(16),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(context.w(14)),
          border: Border(
            top: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: isSelected?5.0:1.0,
            ),
            left: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: 1.0,
            ),
            right: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: context.sp(24))),
            SizedBox(width: context.w(16)),
            Expanded(
              child: AppText(
                data: label,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.w(22),
              height: context.w(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFF5A623) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFFF5A623) : Colors.white38,
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

class _UnitToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final String selected;
  final ValueChanged<String> onChanged;

  const _UnitToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _UnitButton(
          label: leftLabel,
          isActive: selected == leftLabel,
          onTap: () => onChanged(leftLabel),
        ),
        _UnitButton(
          label: rightLabel,
          isActive: selected == rightLabel,
          onTap: () => onChanged(rightLabel),
        ),
      ],
    );
  }
}

class _UnitButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _UnitButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(54),
          vertical: context.h(8),
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF5A623) : Colors.transparent,
          borderRadius: BorderRadius.circular(context.w(10)),
          border: Border.all(
            color: isActive ? const Color(0xFFF5A623) : Colors.white38,
          ),
        ),
        child: AppText(
          data: label,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _EditableValueBox extends StatelessWidget {
  final TextEditingController controller;
  final String unit;

  const _EditableValueBox({required this.controller, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(10),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(context.w(12)),
          ),
          child: IntrinsicWidth(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: context.sp(36),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffix: AppText(
                  data: ' $unit',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.h(10)),
        AppText(
          data: 'Tap the number to edit',
          fontSize: 13,
          color: Colors.white38,
        ),
      ],
    );
  }
}

// ── Step 0: Age ─────────────────────────────────────────────────────────────

class _AgeStep extends StatelessWidget {
  const _AgeStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.h(32)),
        _StepTitle('What\'s your Age?'),
        Expanded(
          child: Obx(() => ListWheelScrollView.useDelegate(
            itemExtent: context.h(72),
            perspective: 0.003,
            diameterRatio: 1.8,
            onSelectedItemChanged: (index) {
              controller.selectedAge.value = index + 10;
            },
            controller: FixedExtentScrollController(
              initialItem: controller.selectedAge.value - 10,
            ),
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 83,
              builder: (context, index) {
                final age = index + 10;
                final isSelected = age == controller.selectedAge.value;
                return Center(
                  child: isSelected
                      ? Container(
                    width: context.w(100),
                    height: context.h(80),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(context.w(20)),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      data: '$age',
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  )
                      : AppText(
                    data: '$age',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white24,
                  ),
                );
              },
            ),
          )),
        ),
      ],
    );
  }
}

// ── Step 1: Weight ───────────────────────────────────────────────────────────

class _WeightStep extends StatelessWidget {
  const _WeightStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('What\'s your current weight?'),
          SizedBox(height: context.h(32)),
          Obx(() => _UnitToggle(
            leftLabel: 'KG',
            rightLabel: 'Lbs',
            selected: controller.weightUnit.value,
            onChanged: (val) => controller.weightUnit.value = val,
          )),
          SizedBox(height: context.h(32)),
          Obx(() => Center(
            child: _EditableValueBox(
              controller: controller.weightController,
              unit: controller.weightUnit.value,
            ),
          )),
        ],
      ),
    );
  }
}

// ── Step 2: Gender ───────────────────────────────────────────────────────────

class _GenderStep extends StatelessWidget {
  const _GenderStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('What\'s your gender?'),
          SizedBox(height: context.h(32)),
          Obx(() => Column(
            children: controller.genders
                .map((g) => _SelectionTile(
              emoji: g['emoji']!,
              label: g['label']!,
              isSelected: controller.selectedGender.value == g['label'],
              onTap: () => controller.selectedGender.value = g['label']!,
            ))
                .toList(),
          )),
        ],
      ),
    );
  }
}

// ── Step 3: Height ───────────────────────────────────────────────────────────

class _HeightStep extends StatelessWidget {
  const _HeightStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('What\'s your current Height?'),
          SizedBox(height: context.h(32)),
          Obx(() => _UnitToggle(
            leftLabel: 'Cm',
            rightLabel: 'Fit',
            selected: controller.heightUnit.value,
            onChanged: (val) => controller.heightUnit.value = val,
          )),
          SizedBox(height: context.h(32)),
          Obx(() => Center(
            child: _EditableValueBox(
              controller: controller.heightController,
              unit: controller.heightUnit.value,
            ),
          )),
        ],
      ),
    );
  }
}

// ── Step 4: Diet ─────────────────────────────────────────────────────────────

class _DietStep extends StatelessWidget {
  const _DietStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('Do you follow any diet?'),
          SizedBox(height: context.h(32)),
          Obx(() => Column(
            children: controller.diets
                .map((d) => _SelectionTile(
              emoji: d['emoji']!,
              label: d['label']!,
              isSelected: controller.selectedDiet.value == d['label'],
              onTap: () => controller.selectedDiet.value = d['label']!,
            ))
                .toList(),
          )),
        ],
      ),
    );
  }
}

// ── Step 5: Goal ─────────────────────────────────────────────────────────────

class _GoalStep extends StatelessWidget {
  const _GoalStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('What\'s Your Primary Goal?'),
          SizedBox(height: context.h(32)),
          Obx(() => Column(
            children: controller.goals
                .map((g) => _SelectionTile(
              emoji: g['emoji']!,
              label: g['label']!,
              isSelected: controller.selectedGoal.value == g['label'],
              onTap: () => controller.selectedGoal.value = g['label']!,
            ))
                .toList(),
          )),
        ],
      ),
    );
  }
}

// ── Step 6: Activity Level ───────────────────────────────────────────────────

class _ActivityStep extends StatelessWidget {
  const _ActivityStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('What\'s Your Primary Goal?'),
          SizedBox(height: context.h(32)),
          Obx(() => Column(
            children: controller.activities
                .map((a) => _SelectionTile(
              emoji: a['emoji']!,
              label: a['label']!,
              isSelected: controller.selectedActivity.value == a['label'],
              onTap: () => controller.selectedActivity.value = a['label']!,
            ))
                .toList(),
          )),
        ],
      ),
    );
  }
}

// ── Step 7: Workout Time ─────────────────────────────────────────────────────

class _WorkoutTimeStep extends StatelessWidget {
  const _WorkoutTimeStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('When do you usually work out?'),
          SizedBox(height: context.h(32)),
          Obx(() => Column(
            children: controller.workoutTimes
                .map((w) => _SelectionTile(
              emoji: w['emoji']!,
              label: w['label']!,
              isSelected: controller.selectedWorkoutTime.value == w['label'],
              onTap: () => controller.selectedWorkoutTime.value = w['label']!,
            ))
                .toList(),
          )),
        ],
      ),
    );
  }
}

// ── Step 8: Mascot ───────────────────────────────────────────────────────────

// ── Step 8: Mascot ───────────────────────────────────────────────────────────

class _MascotStep extends StatelessWidget {
  const _MascotStep();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserInfoController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(32)),
          _StepTitle('Choose your workout buddy!'),
          SizedBox(height: context.h(32)),
          Obx(() {
            final selected = controller.selectedMascot.value;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: context.h(12),
                crossAxisSpacing: context.w(12),
                childAspectRatio: 0.78,
              ),
              itemCount: controller.mascots.length,
              itemBuilder: (context, index) {
                final m = controller.mascots[index];
                return _MascotTile(
                  image: m['image']!,
                  label: m['label']!,
                  isSelected: selected == m['label'],
                  onTap: () => controller.selectedMascot.value = m['label']!,
                );
              },
            );
          }),
          SizedBox(height: context.h(16)),
        ],
      ),
    );
  }
}

class _MascotTile extends StatelessWidget {
  final String image;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MascotTile({
    required this.image,
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
        padding: EdgeInsets.all(context.w(12)),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(context.w(14)),
          border: Border(
            top: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: isSelected ? 5.0 : 1.0,
            ),
            left: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: 1.0,
            ),
            right: BorderSide(
              color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF6b6b6b),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            SizedBox(height: context.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AppText(
                    data: label,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: context.w(8)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: context.w(18),
                  height: context.w(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFF5A623) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFF5A623) : Colors.white38,
                      width: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
