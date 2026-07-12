import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/views/sign_in_screen.dart';
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
  final isRunning       = true.obs;
  final isSavingAchievement = false.obs;
  Timer? _timer;

  final currentIndex    = 0.obs;
  final completedSets   = 0.obs;
  final currentSets     = 0.obs;
  final currentReps     = ''.obs;
  final currentDuration = 0.obs;
  final currentImage    = ''.obs;
  final currentName     = ''.obs;

  // Tracks which exercise IDs have already been submitted this session
  final _submittedExerciseIds = <int>{};

  String get formattedTime {
    final m = (_secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get isLastExercise  => currentIndex.value == allExercises.length - 1;
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
    currentIndex.value    = index;
    currentName.value     = e['name']  as String? ?? '';
    currentSets.value     = int.tryParse(e['sets'].toString()) ?? sets;
    currentReps.value     = e['reps']  as String? ?? '';
    currentDuration.value = _parseDurationSeconds(e['duration'].toString());
    currentImage.value    = e['image'] as String? ?? '';
    completedSets.value   = 0;
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

  // ── Called when user taps "Finish Workout" or "Next Exercise" ─────────────
  Future<void> submitAchievementForCurrent() async {
    final e          = allExercises[currentIndex.value];
    final exerciseId = e['id'] as int?;

    // Guard: skip if no ID or already submitted
    if (exerciseId == null || _submittedExerciseIds.contains(exerciseId)) return;

    final completedRepsRaw = currentReps.value;
    final completedRepsInt = int.tryParse(
      completedRepsRaw.replaceAll(RegExp(r'[^0-9]'), ''),
    ) ?? 0;

    // Convert elapsed seconds to minutes (rounded up, minimum 1)
    final elapsedSeconds  = currentDuration.value - _secondsLeft.value;
    final durationMinutes = ((elapsedSeconds / 60).ceil()).clamp(1, 9999);

    await _postAchievement(
      exerciseId:      exerciseId,
      completedSets:   completedSets.value,
      completedReps:   completedRepsInt,
      durationMinutes: durationMinutes,
    );

    _submittedExerciseIds.add(exerciseId);
  }

  Future<void> _postAchievement({
    required int exerciseId,
    required int completedSets,
    required int completedReps,
    required int durationMinutes,
  }) async {
    isSavingAchievement.value = true;
    String endpoint = AppConstant.achievementsEndpoint;

    try {
      final body = jsonEncode({
        'exercise':         exerciseId,
        'notes':            '',
        'completed_sets':   completedSets,
        'completed_reps':   completedReps,
        'duration_minutes': durationMinutes,
      });

      AppLog.request(endpoint, method: 'POST');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
          'Content-Type':  'application/json',
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        AppLog.response(endpoint, data);
        // Optionally: show XP earned toast
        // final xpEarned = data['xp_earned'] ?? 0;
        // Get.snackbar('🏆 XP Earned', '+$xpEarned XP', ...);
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
      isSavingAchievement.value = false;
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

  void pause()        { _timer?.cancel(); isRunning.value = false; }
  void resume()       => _startTimer();
  void togglePause()  => isRunning.value ? pause() : resume();

  void restart() {
    _timer?.cancel();
    _secondsLeft.value  = currentDuration.value;
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