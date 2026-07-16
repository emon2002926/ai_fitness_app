import 'package:ai_fitness_app/core/constants/app_assert_image.dart';
import 'package:flutter/material.dart';
import '../../../core/util/screen_size.dart';
import 'package:get/get.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/shimmer/app_shimmer.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/home_controller.dart';
import 'home_shimmer.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && !controller.hasLoadedOnce.value) {
            return const HomeShimmer();
          }

          return RefreshIndicator(
            color: const Color(0xFFF5A623),
            backgroundColor: const Color(0xFF1A1A1A),
            onRefresh: controller.loadAll,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: context.h(100)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeHeader(controller: controller),
                  SizedBox(height: context.h(20)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LevelCard(controller: controller),
                        SizedBox(height: context.h(16)),
                        _StatsRow(controller: controller),
                        SizedBox(height: context.h(24)),
                        AppText(
                          data: "Today's Plan",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                        ),
                        SizedBox(height: context.h(12)),
                        _TodayPlanCard(controller: controller),
                        SizedBox(height: context.h(16)),
                        _CalorieCard(controller: controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final HomeController controller;
  const _HomeHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(20),
        vertical: context.h(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => AppText(
                  data: 'Hey, ${controller.userName.value}',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                )),
                SizedBox(height: context.h(4)),
                AppText(
                  data: 'Ready to crush it today?',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          _StreakBadge(streak: controller.streakCount),
          SizedBox(width: context.w(12)),
          _NotificationBell(onTap: controller.onNotificationTap),
          SizedBox(width: context.w(12)),
          _AvatarButton(
            imageUrl: controller.avatarUrl.value,
            onTap: (){ controller.onAvatarTap(context);},
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final RxInt streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            data: '${streak.value}',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          SizedBox(width: context.w(4)),
          Text('🔥', style: TextStyle(fontSize: context.sp(14))),
        ],
      ),
    ));
  }
}

class _NotificationBell extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationBell({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: context.sp(26),
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: context.w(8),
              height: context.w(8),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;
  const _AvatarButton({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.w(44),
        height: context.w(44),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF5A623), width: 2),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


class _LevelCard extends StatelessWidget {
  final HomeController controller;
  const _LevelCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(52),
            height: context.w(52),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.w(12)),
              border: Border.all(color: const Color(0xFFF5A623), width: 2),
            ),
            alignment: Alignment.center,
            child: Obx(() => AppText(
              data: '${controller.level.value}',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFF5A623),
            )),
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => AppText(
                  data: 'Level ${controller.level.value}',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
                SizedBox(height: context.h(8)),
                Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(context.w(4)),
                  child: LinearProgressIndicator(
                    value: controller.xpProgress,
                    minHeight: context.h(8),
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFF5A623)),
                  ),
                )),
                SizedBox(height: context.h(4)),
                Obx(() => AppText(
                  data:
                  '${controller.currentXp.value} / ${controller.maxXp.value} XP',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white38,
                )),
              ],
            ),
          ),
          SizedBox(width: context.w(12)),
          Image.asset(
            AppAssertImage.instance.lionLogo,
            width: context.w(60),
            height: context.h(70),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}


class _StatsRow extends StatelessWidget {
  final HomeController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Streak',
            value: '${controller.streakCount.value}',
            iconAsset: AppAssertImage.instance.flameIcon,
          ),
        ),
        SizedBox(width: context.w(10)),
        Expanded(
          child: _StatCard(
            label: 'Workout',
            value: '${controller.workoutCount.value}',
            iconAsset: AppAssertImage.instance.muscleIcon,
          ),
        ),
        SizedBox(width: context.w(10)),
        Expanded(
          child: _StatCard(
            label: 'Goal progress',
            value: '${controller.goalProgress.value}%',
            iconAsset: AppAssertImage.instance.flameIcon,
          ),
        ),
      ],
    ));
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconAsset;

  const _StatCard({
    required this.label,
    required this.value,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: Colors.white70),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                data: label,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white54,
              ),
              SizedBox(height: context.h(8)),
              AppText(
                data: value,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                iconAsset,
                width: context.w(36),
                height: context.w(36),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }}


class _TodayPlanCard extends StatelessWidget {
  final HomeController controller;
  const _TodayPlanCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(200),
      width: context.widthPercentage(100),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: Colors.white70),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: 0, top: 0, bottom: 0,
            width: context.w(230),
            child: Image.asset(AppAssertImage.instance.workoutBanner, fit: BoxFit.cover),
          ),
          Positioned(
            right: context.w(190), top: 0, bottom: 0,
            width: context.w(40),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF1A1A1A), Colors.transparent],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => AppText(
                  data: controller.todayWorkoutName.value,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
                SizedBox(height: context.h(6)),
                Obx(() => AppText(
                  data:
                  '${controller.workoutDuration.value} min • ${controller.exerciseCount.value} Exercises • ${controller.workoutXp.value} Xp',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFF5A623),
                )),
                SizedBox(height: context.h(16)),
                AppButton(
                  buttonText: 'Start Workout',
                  onPressed: (){controller.onStartWorkout(context);},
                  fillColor: const Color(0xFFF5A623),
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 10,
                  fontWeight: FontWeight.w600,
                  buttonWidth: context.w(150),
                  buttonHeight: 44,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _CalorieCard extends StatelessWidget {
  final HomeController controller;
  const _CalorieCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          Obx(() => _CalorieRing(
            kcalLeft: controller.kcalLeft.value,
            kcalTotal: controller.kcalTotal.value,
          )),
          SizedBox(height: context.h(16)),
          Container(
            padding: EdgeInsets.all(context.w(14)),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(context.w(12)),
              border: Border.all(color: Colors.white12),
            ),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroItem(
                  emoji: '🍗',
                  label: 'Protein',
                  value: controller.proteinLeft.value,
                  unit: 'kcal left',
                  trackColor: const Color(0xFFE57373),
                ),
                Container(width: 1, height: context.h(60), color: Colors.white12),
                _MacroItem(
                  emoji: '🌾',
                  label: 'Carbs',
                  value: controller.carbsLeft.value,
                  unit: '${controller.carbsGLeft.value}g left',
                  trackColor: const Color(0xFFF5A623),
                ),
                Container(width: 1, height: context.h(60), color: Colors.white12),
                _MacroItem(
                  emoji: '🥩',
                  label: 'Fat',
                  value: controller.fatLeft.value,
                  unit: '${controller.fatGLeft.value}g left',
                  trackColor: const Color(0xFF9C27B0),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class _CalorieRing extends StatelessWidget {
  final int kcalLeft;
  final int kcalTotal;
  const _CalorieRing({required this.kcalLeft, required this.kcalTotal});

  @override
  Widget build(BuildContext context) {
    final progress = kcalTotal > 0 ? (kcalLeft / kcalTotal).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: context.w(200),
      height: context.w(200),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: context.w(200),
            height: context.w(200),
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: context.w(14),
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFF5A623)),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                data: '$kcalLeft',
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              AppText(
                data: 'kcal left',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String emoji;
  final String label;
  final int value;
  final String unit;
  final Color trackColor;

  const _MacroItem({
    required this.emoji,
    required this.label,
    required this.value,
    required this.unit,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: TextStyle(fontSize: context.sp(20))),
            SizedBox(height: context.h(4)),
            AppText(
              data: label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            AppText(
              data: unit,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white38,
            ),
          ],
        ),
        SizedBox(width: context.w(8)),
        SizedBox(
          width: context.w(36),
          height: context.w(36),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 0.6,
                strokeWidth: 3,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(trackColor),
                strokeCap: StrokeCap.round,
              ),
              AppText(
                data: '$value',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}