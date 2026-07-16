import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/views/sign_in_screen.dart';

enum LevelState { completed, current, locked }

class LevelItem {
  final int level;
  final LevelState state;
  final bool hasMascot;

  const LevelItem({
    required this.level,
    required this.state,
    this.hasMascot = false,
  });
}

class LevelsController extends GetxController {
  final isLoading    = true.obs;
  final hasLoadedOnce = false.obs;
  final currentLevel = 0.obs;
  final currentXp    = 0.obs;
  final maxXp        = 0.obs;
  final levels       = <LevelItem>[].obs;

  double get xpProgress =>
      maxXp.value > 0 ? (currentXp.value / maxXp.value).clamp(0.0, 1.0) : 0.0;

  @override
  void onInit() {
    super.onInit();
    fetchLevelData();
  }

  Future<void> fetchLevelData() async {
    isLoading.value = true;
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
        currentXp.value    = d['total_xp']      ?? 0;
        maxXp.value        = d['target_xp']      ?? 0;
        currentLevel.value = d['current_level']  ?? 1;

        _buildLevelPath(currentLevel.value);
      } else if (response.statusCode == 401) {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    } finally {
      isLoading.value = false;
      hasLoadedOnce.value = true;
    }
  }

  void _buildLevelPath(int current) {
    const visibleCount = 7;
    final startLevel = (current - 2).clamp(1, 9999);

    levels.value = List.generate(visibleCount, (i) {
      final lvl = startLevel + i;
      final isCurrent = lvl == current;
      final isCompleted = lvl < current;

      return LevelItem(
        level:     lvl,
        state:     isCurrent
            ? LevelState.current
            : isCompleted
            ? LevelState.completed
            : LevelState.locked,
        hasMascot: isCurrent,
      );
    });
  }

  void onNotificationPressed() {}
  void onAvatarPressed() {}
}