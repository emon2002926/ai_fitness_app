import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/controllers/mascot_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Profile',
        showBackButton: true,
        showNotification: true,
        onNotificationPressed: controller.onNotificationPressed,
        avatarUrl: controller.avatarUrl.value.isEmpty
            ? null
            : controller.avatarUrl.value,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFF5A623),
          backgroundColor: const Color(0xFF1A1A1A),
          onRefresh: controller.fetchAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: context.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(24)),
                _ProfileHeader(controller: controller),
                SizedBox(height: context.h(24)),
                _LevelCard(controller: controller),
                SizedBox(height: context.h(16)),
                _StatsRow(controller: controller),
                SizedBox(height: context.h(28)),
                _SectionLabel(label: 'Personal Details'),
                SizedBox(height: context.h(12)),
                _PersonalDetailsCard(controller: controller),
                SizedBox(height: context.h(28)),
                _SectionLabel(label: 'Support & Legal'),
                SizedBox(height: context.h(12)),
                _SupportCard(controller: controller),
                SizedBox(height: context.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: context.w(100),
            height: context.w(100),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF5A623), width: 3),
            ),
            child: ClipOval(
              child: Obx(() => controller.avatarUrl.value.isNotEmpty
                  ? Image.network(
                controller.avatarUrl.value,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                AppAssertImage.instance.workoutBanner,
                fit: BoxFit.cover,
              )),
            ),
          ),

          SizedBox(height: context.h(12)),

          Obx(() => AppText(
            data: controller.userName.value,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),

          SizedBox(height: context.h(8)),

          Obx(() => controller.isPremium.value
              ? Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.w(20), vertical: context.h(6)),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('👑', style: TextStyle(fontSize: 14)),
                SizedBox(width: context.w(6)),
                AppText(
                  data: 'Premium User',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ],
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}


class _LevelCard extends StatelessWidget {
  final ProfileController controller;
  const _LevelCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Obx(() => Row(
        children: [
          // Level badge
          Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border:
              Border.all(color: const Color(0xFFF5A623), width: 1.5),
            ),
            child: Center(
              child: AppText(
                data: '${controller.level.value}',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF5A623),
              ),
            ),
          ),

          SizedBox(width: context.w(14)),

          // XP bar + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'Level ${controller.level.value}',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                SizedBox(height: context.h(8)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: controller.xpProgress,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF5A623)),
                    minHeight: 6,
                  ),
                ),
                SizedBox(height: context.h(6)),
                AppText(
                  data:
                  '${_formatXp(controller.currentXp.value)} / ${_formatXp(controller.maxXp.value)} XP',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                ),
              ],
            ),
          ),

          SizedBox(width: context.w(12)),

          // Trophy illustration
          Image.asset(MascotController.to.image,width: context.w(60),height: context.w(60),)
          // const Text('🏆', style: TextStyle(fontSize: 36)),
        ],
      )),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(xp % 1000 == 0 ? 0 : 1)}k';
    }
    return '$xp';
  }
}


class _StatsRow extends StatelessWidget {
  final ProfileController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _StatCard(
            emoji: '🔥',
            value: '${controller.dayStreak.value}',
            label: 'Day Streak',
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: _StatCard(
            emoji: '🏋️',
            value: '${controller.workoutCount.value}',
            label: 'Workout',
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: _StatCard(
            emoji: '🏆',
            value: '+${controller.kgGained.value.toStringAsFixed(2)}',
            label: 'Kg Gained',
          ),
        ),
      ],
    ));
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: context.h(16), horizontal: context.w(8)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFF3F4F6), width: 1),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          SizedBox(height: context.h(8)),
          AppText(
            data: value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          SizedBox(height: context.h(4)),
          AppText(
            data: label,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      data: label,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}


class _PersonalDetailsCard extends StatelessWidget {
  final ProfileController controller;
  const _PersonalDetailsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _DetailContainer(
      children: [
        _DetailRow(
          icon: Icons.monitor_weight_outlined,
          label: 'Current Weight',
          value: controller.currentWeight.value,
          onTap: (){controller.currentWeightTap(context);},
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.straighten_outlined,
          label: 'Height',
          value: controller.height.value,
          onTap: () { controller.heightTap(context);},
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.cake_outlined,
          label: 'Age',
          value: controller.age.value,
          onTap: () {controller.ageTap(context);},
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.track_changes_outlined,
          label: 'Goal',
          value: controller.goal.value,
          onTap: () {controller.goalTap(context);},
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.restaurant_menu_outlined,
          label: 'Diet',
          value: controller.diet.value,
          onTap: () { controller.dietTap(context);},
          isLast: true,
        ),
      ],
    ));
  }
}



class _SupportCard extends StatelessWidget {
  final ProfileController controller;
  const _SupportCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _DetailContainer(
      children: [
        _DetailRow(
          icon: Icons.handshake_outlined,
          label: 'Support & Legal',
          onTap: (){controller.onSupportAndLegal(context);},
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.shield_outlined,
          label: 'Privacy Policy',
          onTap: (){controller.onPrivacyPolicy(context);},
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.help_outline,
          label: 'Terms & Conditions',
          onTap: (){controller.onTermsAndConditions(context);},
          isLast: true,
        ),
        _Divider(),
        _DetailRow(
          icon: Icons.logout,
          label: 'Log Out',
          onTap: (){controller.onLogOut(context);},
          isLast: true,
        ),
      ],
    );
  }
}



class _DetailContainer extends StatelessWidget {
  final List<Widget> children;
  const _DetailContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF3F4F6), width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.w(16), vertical: context.h(16)),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFF5A623), size: context.sp(20)),
            SizedBox(width: context.w(12)),
            Expanded(
              child: AppText(
                data: label,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (value != null) ...[
              AppText(
                data: value!,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white54,
              ),
              SizedBox(width: context.w(4)),
            ],
            const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.white12,
      indent: 16,
      endIndent: 16,
    );
  }
}