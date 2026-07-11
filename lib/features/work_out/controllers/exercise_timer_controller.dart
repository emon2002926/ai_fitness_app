import 'dart:async';

import 'package:get/get.dart';
class ExerciseTimerController extends GetxController {
  final String exerciseName;
  final int sets;
  final String reps;
  final int durationSeconds;
  final String exerciseImage;
  final List<Map<String, dynamic>> allExercises;
  final int startIndex;

  ExerciseTimerController({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.durationSeconds,
    required this.exerciseImage,
    required this.allExercises,
    required this.startIndex,
  });

  late final RxInt _secondsLeft = durationSeconds.obs;
  final isRunning = true.obs;
  Timer? _timer;

  final currentIndex = 0.obs;
  final completedSets = 0.obs;
  final currentSets = 0.obs;
  final currentReps = ''.obs;
  final currentDuration = 0.obs;
  final currentImage = ''.obs;
  final currentName = ''.obs;

  String get formattedTime {
    final m = (_secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get isLastExercise => currentIndex.value == allExercises.length - 1;
  bool get isFirstExercise => currentIndex.value == 0;

  @override
  void onReady() {
    super.onReady();
    _loadExercise(startIndex);
    _startTimer();
  }

  void _loadExercise(int index) {
    if (index < 0 || index >= allExercises.length) return;
    final e = allExercises[index];
    currentIndex.value   = index;
    currentName.value    = e['name'] as String? ?? '';
    currentSets.value    = int.tryParse(e['sets'].toString()) ?? sets;
    currentReps.value    = e['reps'] as String? ?? '';
    currentDuration.value = _parseDurationSeconds(e['duration'].toString());
    currentImage.value   = e['image'] as String? ?? '';
    completedSets.value  = 0;

    _timer?.cancel();
    _secondsLeft.value = currentDuration.value;
    _startTimer();
  }

  void nextExercise() {
    if (!isLastExercise) _loadExercise(currentIndex.value + 1);
  }

  void previousExercise() {
    if (!isFirstExercise) _loadExercise(currentIndex.value - 1);
  }

  void completeSet() {
    if (completedSets.value < currentSets.value) {
      completedSets.value++;
      _timer?.cancel();
      _secondsLeft.value = currentDuration.value;
      if (completedSets.value < currentSets.value) _startTimer();
    }
  }

  void _startTimer() {
    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft.value > 0) {
        _secondsLeft.value--;
      } else {
        _timer?.cancel();
        isRunning.value = false;
      }
    });
  }

  void pause() {
    _timer?.cancel();
    isRunning.value = false;
  }

  void resume() => _startTimer();

  void togglePause() => isRunning.value ? pause() : resume();

  void restart() {
    _timer?.cancel();
    _secondsLeft.value = currentDuration.value;
    completedSets.value = 0;
    _startTimer();
  }

  RxInt get secondsLeft => _secondsLeft;

  int _parseDurationSeconds(String raw) {
    final match = RegExp(
      r'(\d+)\s*(minute|min|second|sec)',
      caseSensitive: false,
    ).firstMatch(raw);
    if (match == null) return durationSeconds;
    final value = int.parse(match.group(1)!);
    final unit  = match.group(2)!.toLowerCase();
    return unit.startsWith('s') ? value : value * 60;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}