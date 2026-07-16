import 'package:flutter/material.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import 'package:get/get.dart';
import '../controllers/nutrition_controller.dart';
import 'cooking_steps_screen.dart';
class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<NutritionController>()
        ? Get.find<NutritionController>()
        : Get.put(NutritionController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Nutrition',
        showNotification: true,
        showBackButton: false,
        avatarUrl: 'assets/images/avatar.png',
        onNotificationPressed: () {},
      ),
      body: Obx(() {
        if (controller.isLoading.value && !controller.hasLoadedOnce.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF5A623)),
          );
        }
        return RefreshIndicator(
          color: const Color(0xFFF5A623),
          backgroundColor: const Color(0xFF1A1A1A),
          onRefresh: controller.fetchMealPlan,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: context.h(100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(20)),
                _WeekDayPicker(controller: controller),
                SizedBox(height: context.h(24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                  child: Obx(() => Column(
                    children: controller.meals
                        .map((section) => _MealSection(section: section))
                        .toList(),
                  )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _WeekDayPicker extends StatelessWidget {
  final NutritionController controller;
  const _WeekDayPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(72),
      child: Obx(() {
        final selectedIndex = controller.selectedDayIndex.value;  // ✅ read here
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.w(20)),
          itemCount: controller.days.length,
          separatorBuilder: (_, _) => SizedBox(width: context.w(10)),
          itemBuilder: (context, index) {
            final day = controller.days[index];
            final isSelected = selectedIndex == index;  // ✅ use local variable

            return GestureDetector(
              onTap: () => controller.selectDay(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: context.w(60),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(context.w(14)),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white70,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      data: day['day']!,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    SizedBox(height: context.h(2)),
                    AppText(
                      data: day['label']!,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white70 : Colors.white38,
                    )],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


class _MealSection extends StatelessWidget {
  final MealSection section;
  const _MealSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
              ),
              child: Icon(
                Icons.fastfood_outlined,
                color: const Color(0xFFF5A623),
                size: context.sp(18),
              ),
            ),
            SizedBox(width: context.w(12)),
            AppText(
              data: section.title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF5A623),
            ),
          ],
        ),
        SizedBox(height: context.h(12)),
        ...section.items.map((item) => _MealCard(item: item)),
        SizedBox(height: context.h(24)),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealItem item;

  const _MealCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigation.push(
        CookingStepsScreen(meal: item),
        context: context,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(12)),
        padding: EdgeInsets.all(context.w(14)),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(context.w(14)),
          border: Border.all(color: Colors.white70),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                item.image,
                width: context.w(72),
                height: context.w(72),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: item.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  SizedBox(height: context.h(6)),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, color: Colors.white38, size: context.sp(14)),
                      SizedBox(width: context.w(4)),
                      AppText(
                        data: '${item.minutes} min',
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                      SizedBox(width: context.w(12)),
                      Icon(Icons.local_fire_department_outlined, color: Colors.white38, size: context.sp(14)),
                      SizedBox(width: context.w(4)),
                      AppText(
                        data: '${item.kcal} kcal',
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(4)),
                  Row(
                    children: [
                      Icon(Icons.fitness_center_rounded, color: Colors.white38, size: context.sp(14)),
                      SizedBox(width: context.w(4)),
                      AppText(
                        data: '${item.protein} gm',
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                      SizedBox(width: context.w(12)),
                      Icon(Icons.emoji_events_outlined, color: Colors.white38, size: context.sp(14)),
                      SizedBox(width: context.w(4)),
                      AppText(
                        data: '${item.xp} Xp',
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NutritionController>();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(28))),
      ),
      padding: EdgeInsets.fromLTRB(
        context.w(24),
        context.h(12),
        context.w(24),
        context.h(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.w(40),
            height: context.h(4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(context.w(2)),
            ),
          ),
          SizedBox(height: context.h(28)),
          Container(
            width: context.w(64),
            height: context.w(64),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
            ),
            child: Icon(
              Icons.pie_chart_outline_rounded,
              color: const Color(0xFFF5A623),
              size: context.sp(30),
            ),
          ),
          SizedBox(height: context.h(20)),
          AppText(
            data: 'AI Meal Plan',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          SizedBox(height: context.h(10)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(6),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A1F00),
              borderRadius: BorderRadius.circular(context.w(20)),
            ),
            child: AppText(
              data: 'Premium Feature',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF5A623),
            ),
          ),
          SizedBox(height: context.h(16)),
          AppText(
            data: 'Unlock personalized nutrition, macro tracking,\nand smart grocery lists.',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.h(24)),
          ...[
            'AI-personalized daily meals',
            'Exact macro & calorie tracking',
            'Smart grocery lists',
            '1000+ healthy recipes',
          ].map((feature) => Padding(
            padding: EdgeInsets.only(bottom: context.h(14)),
            child: Row(
              children: [
                Container(
                  width: context.w(28),
                  height: context.w(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: const Color(0xFFF5A623),
                    size: context.sp(16),
                  ),
                ),
                SizedBox(width: context.w(14)),
                AppText(
                  data: feature,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          )),
          SizedBox(height: context.h(24)),
          AppButton(
            buttonText: 'UNLOCK FOR \$9.99/MO',
            onPressed: controller.unlock,
            fillColor: const Color(0xFFF5A623),
            textColor: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: context.h(16)),
          AppText(
            data: 'Cancel anytime. All other app features remain free.',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white38,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}