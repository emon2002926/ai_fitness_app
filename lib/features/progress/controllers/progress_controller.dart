import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/views/sign_in_screen.dart';

class WeeklyCalorieData {
  final String day;
  final double calories;
  final double fat;
  final double carbs;
  final double protein;

  const WeeklyCalorieData({
    required this.day,
    required this.calories,
    required this.fat,
    required this.carbs,
    required this.protein,
  });
}

class WeightEntry {
  final DateTime date;
  final double weight;

  const WeightEntry({required this.date, required this.weight});
}

class ProgressController extends GetxController {
  final isLoading = true.obs;
  final hasLoadedOnce = false.obs;

  // Stats (home/onboarding)
  final dayStreak = 0.obs;

  // Stats — no API provided for these yet.
  final int mealsLogged = 42;
  final double kgGained = 5.30;

  // Weekly chart (achievements/report)
  final selectedDayIndex = 0.obs;
  final weeklyData = <WeeklyCalorieData>[].obs;

  // Weight progress (weight-tracking + weight-summary)
  final currentWeight = 0.0.obs;
  final weightGainBadge = 0.0.obs;
  final weightHistory = <WeightEntry>[].obs;
  final Rx<WeightEntry?> weightGoal = Rx<WeightEntry?>(null);

  // Weight progress summary (weight-summary)
  final gain3Days = 0.0.obs;
  final gain7Days = 0.0.obs;
  final gain30Days = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProgressData();
  }

  Future<void> fetchProgressData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchHomeStats(),
        _fetchWeeklyReport(),
        _fetchWeightTracking(),
        _fetchWeightSummary(),
      ]);
      _computeWeightGainBadge();
    } finally {
      isLoading.value = false;
      hasLoadedOnce.value = true;
    }
  }

  Future<void> _fetchHomeStats() async {
    const endpoint = AppConstant.homeEndpoint;

    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final d = data['data'] as Map<String, dynamic>? ?? {};
        dayStreak.value = (d['streak'] as num?)?.toInt() ?? 0;
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

  Future<void> _fetchWeeklyReport() async {
    const endpoint = AppConstant.weeklyAchievementsReportEndpoint;

    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final list      = data as List;
        final todayStr   = DateTime.now().toIso8601String().substring(0, 10);

        weeklyData.value = list.map((e) {
          final m        = e as Map<String, dynamic>;
          final progress = m['progress'] as Map<String, dynamic>? ?? {};
          final fat      = (progress['fat']     as num?)?.toDouble() ?? 0;
          final carbs    = (progress['carbs']   as num?)?.toDouble() ?? 0;
          final protein  = (progress['protein'] as num?)?.toDouble() ?? 0;
          final dayName  = m['day'] as String? ?? '';

          return WeeklyCalorieData(
            day:      dayName.isNotEmpty ? dayName[0] : '-',
            calories: fat * 9 + carbs * 4 + protein * 4,
            fat:      fat,
            carbs:    carbs,
            protein:  protein,
          );
        }).toList();

        if (weeklyData.isNotEmpty) {
          final todayIndex = list.indexWhere((e) => e['date'] == todayStr);
          selectedDayIndex.value = todayIndex != -1 ? todayIndex : weeklyData.length - 1;
        }
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

  Future<void> _fetchWeightTracking() async {
    const endpoint = AppConstant.weightTrackingEndpoint;

    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final list = data as List;
        final entries = list.map((e) {
          final m = e as Map<String, dynamic>;
          return WeightEntry(
            date:   DateTime.tryParse(m['date'] as String? ?? '') ?? DateTime.now(),
            weight: double.tryParse('${m['weight']}') ?? 0,
          );
        }).toList()
          ..sort((a, b) => a.date.compareTo(b.date));

        weightHistory.value = entries;
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

  Future<void> _fetchWeightSummary() async {
    const endpoint = AppConstant.weightSummaryEndpoint;

    try {
      AppLog.request(endpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        final m       = data as Map<String, dynamic>;
        final summary = m['summary'] as Map<String, dynamic>? ?? {};

        currentWeight.value = (m['current_weight'] as num?)?.toDouble() ?? 0;
        gain3Days.value  = _changeOf(summary['last_3_days']);
        gain7Days.value  = _changeOf(summary['last_7_days']);
        gain30Days.value = _changeOf(summary['last_30_days']);
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

  double _changeOf(dynamic period) {
    if (period == null) return 0;
    final change = (period as Map<String, dynamic>)['change'] as num?;
    return change?.toDouble() ?? 0;
  }

  void _computeWeightGainBadge() {
    if (weightHistory.isEmpty) return;
    weightGainBadge.value = currentWeight.value - weightHistory.first.weight;
  }

  void onNotificationPressed() {}
  void onAvatarPressed() {}
  void onUpdateWeight() {}
}
