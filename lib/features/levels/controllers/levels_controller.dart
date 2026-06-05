import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelNode {
  final int level;
  final bool isCompleted;
  final bool isCurrent;

  const LevelNode({
    required this.level,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class LevelsController extends GetxController {
  final currentLevel = 12.obs;
  final currentXp = 8450.obs;
  final maxXp = 12000.obs;

  double get xpProgress => (currentXp.value / maxXp.value).clamp(0.0, 1.0);

  late final List<LevelNode> levelNodes;

  @override
  void onInit() {
    super.onInit();
    levelNodes = List.generate(16, (i) {
      final level = i + 1;
      return LevelNode(
        level: level,
        isCompleted: level < currentLevel.value,
        isCurrent: level == currentLevel.value,
      );
    });
  }

  // Zigzag positions: alternates right-center-left
  Alignment alignmentForIndex(int index) {
    final mod = index % 3;
    if (mod == 0) return Alignment.centerRight;
    if (mod == 1) return Alignment.center;
    return Alignment.centerLeft;
  }
}