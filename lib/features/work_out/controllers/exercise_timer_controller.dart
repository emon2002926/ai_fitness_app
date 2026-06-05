import 'dart:async';

import 'package:get/get.dart';
class ExerciseTimerController extends GetxController {
  final String exerciseName;
  final int sets;
  final int reps;
  final int durationSeconds;
  final String exerciseImage;

  ExerciseTimerController({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.durationSeconds,
    required this.exerciseImage,
  });

  late final RxInt _secondsLeft = durationSeconds.obs;
  final isRunning = true.obs;
  Timer? _timer;

  String get formattedTime {
    final m = (_secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void onReady() {
    super.onReady();
    _startTimer();
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

  void resume() {
    _startTimer();
  }

  void togglePause() {
    if (isRunning.value) {
      pause();
    } else {
      resume();
    }
  }

  void restart() {
    _timer?.cancel();
    _secondsLeft.value = durationSeconds;
    _startTimer();
  }

  RxInt get secondsLeft => _secondsLeft;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}