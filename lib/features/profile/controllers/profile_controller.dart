import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observables – replace with real data from your API/storage
  final userName = 'User'.obs;
  final avatarUrl = ''.obs; // set to network URL when available
  final isPremium = true.obs;

  // Level / XP
  final level = 12.obs;
  final currentXp = 8450.obs;
  final maxXp = 12000.obs;

  // Stats
  final dayStreak = 14.obs;
  final workoutCount = 42.obs;
  final kgGained = 5.30.obs;

  // Personal details
  final currentWeight = '70 kg'.obs;
  final height = '169 cm'.obs;
  final age = '19 Years'.obs;
  final goal = 'Endurance'.obs;
  final diet = 'Vegetarian'.obs;

  double get xpProgress => currentXp.value / maxXp.value;

  void onNotificationPressed() {
    // TODO: navigate to notifications
  }

  void onAvatarPressed() {
    // TODO: open full profile / edit
  }

  void onPersonalDetailTap(String field) {
    // TODO: navigate to edit screen for each field
  }

  void onSupportAndLegal() {}
  void onPrivacyPolicy() {}
  void onTermsAndConditions() {}
}

