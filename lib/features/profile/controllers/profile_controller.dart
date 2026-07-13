import 'dart:convert';

import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:ai_fitness_app/core/util/storage_service.dart';
import 'package:ai_fitness_app/features/auth/views/sign_in_screen.dart';
import 'package:ai_fitness_app/features/profile/views/terms_conditions_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_age_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_diet_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_goal_screen.dart';
import 'package:ai_fitness_app/features/profile/widgets/edit_height_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../views/privacy_policy_screen.dart';
import '../views/support_legal_screen.dart';
import '../widgets/edit_weight_screen.dart';

class ProfileController extends GetxController {
  final isLoading = true.obs;

  final userName  = 'User'.obs;
  final avatarUrl = ''.obs;
  final isPremium = true.obs;

  final level      = 0.obs;
  final currentXp  = 0.obs;
  final maxXp      = 0.obs;

  final dayStreak    = 0.obs;
  final workoutCount = 0.obs;
  final kgGained     = 0.0.obs;

  final currentWeight = ''.obs;
  final height        = ''.obs;
  final age           = ''.obs;
  final goal          = ''.obs;
  final diet          = ''.obs;

  double get xpProgress =>
      maxXp.value > 0 ? (currentXp.value / maxXp.value).clamp(0.0, 1.0) : 0.0;

  @override
  void onInit() {
    super.onInit();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    isLoading.value = true;
    await Future.wait([_fetchOnboarding(), _fetchHome()]);
    isLoading.value = false;
  }

  Future<void> _fetchOnboarding() async {
    const endpoint = AppConstant.onboardingEndpointGet;
    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);
        final d = data['data'];

        userName.value      = (d['user']?['full_name'] as String? ?? '').obs.value;
        currentWeight.value = '${d['weight'] ?? ''} kg';
        height.value        = '${d['height'] ?? ''} cm';
        age.value           = '${d['age'] ?? ''} Years';
        goal.value          = d['primary_goal'] as String? ?? '';
        diet.value          = d['diet']         as String? ?? '';
      } else if (response.statusCode == 401) {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    }
  }

  Future<void> _fetchHome() async {
    const endpoint = AppConstant.homeEndpoint;
    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);
        final d = data['data'];

        level.value        = d['current_level']         ?? 0;
        currentXp.value    = d['total_xp']              ?? 0;
        maxXp.value        = d['target_xp']             ?? 0;
        dayStreak.value    = d['streak']                ?? 0;
        workoutCount.value = d['count_of_workouts']     ?? 0;
        kgGained.value     = (d['goal_progress_percentage'] ?? 0).toDouble();
      } else if (response.statusCode == 401) {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    }
  }

  void onNotificationPressed() {}
  void onAvatarPressed() {}

  void onSupportAndLegal(BuildContext context) =>
      AppNavigation.push(SupportLegalScreen(), context: context);

  void onPrivacyPolicy(BuildContext context) =>
      AppNavigation.push(PrivacyPolicyScreen(), context: context);

  void onTermsAndConditions(BuildContext context) =>
      AppNavigation.push(TermsConditionsScreen(), context: context);

  void onLogOut(BuildContext context) async {
    StorageService.logout();
    await Future.delayed(const Duration(milliseconds: 100));
    AppNavigation.pushAndClear(const SignInScreen());
  }

  void currentWeightTap(BuildContext context) =>
      AppNavigation.push(EditWeightScreen(), context: context);

  void heightTap(BuildContext context) =>
      AppNavigation.push(EditHeightScreen(), context: context);

  void ageTap(BuildContext context) =>
      AppNavigation.push(EditAgeScreen(), context: context);

  void goalTap(BuildContext context) =>
      AppNavigation.push(EditGoalScreen(), context: context);

  void dietTap(BuildContext context) =>
      AppNavigation.push(EditDietScreen(), context: context);
}
