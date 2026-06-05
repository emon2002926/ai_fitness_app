import 'package:get/get.dart';




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
  final avatarUrl = ''.obs;

  // Stats
  final int dayStreak = 14;
  final int mealsLogged = 42;
  final double kgGained = 5.30;

  // Weekly chart
  final int selectedDayIndex = 3; // Wednesday
  final List<WeeklyCalorieData> weeklyData = const [
    WeeklyCalorieData(day: 'S', calories: 1000, fat: 30, carbs: 15, protein: 3),
    WeeklyCalorieData(day: 'M', calories: 1200, fat: 35, carbs: 18, protein: 4),
    WeeklyCalorieData(day: 'T', calories: 1600, fat: 38, carbs: 19, protein: 4),
    WeeklyCalorieData(day: 'W', calories: 1550, fat: 40, carbs: 20, protein: 4),
    WeeklyCalorieData(day: 'T', calories: 1700, fat: 42, carbs: 22, protein: 5),
    WeeklyCalorieData(day: 'F', calories: 1750, fat: 44, carbs: 23, protein: 5),
    WeeklyCalorieData(day: 'S', calories: 1980, fat: 48, carbs: 25, protein: 6),
  ];

  // Weight progress
  final double currentWeight = 82.5;
  final double weightGainBadge = 5.0;

  final List<WeightEntry> weightHistory = [
    WeightEntry(date: DateTime(2022, 3, 1), weight: 60),
    WeightEntry(date: DateTime(2023, 6, 1), weight: 62),
    WeightEntry(date: DateTime(2024, 2, 1), weight: 63.5),
    WeightEntry(date: DateTime(2026, 7, 18), weight: 65),
  ];

  final WeightEntry weightGoal = WeightEntry(
    date: DateTime.now(),
    weight: 72,
  );

  // Weight progress summary
  final double gain3Days = 0.2;
  final double gain7Days = 0.8;
  final double gain30Days = 5.30;

  void onNotificationPressed() {}
  void onAvatarPressed() {}
  void onUpdateWeight() {}
}
