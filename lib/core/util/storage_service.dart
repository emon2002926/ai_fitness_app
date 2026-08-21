import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _mascotIndexKey = 'workout_buddy';

  // Access Token
  static Future<void> saveToken(String accessToken) async {
    await _box.write(_tokenKey, accessToken);
  }

  static String? get accessToken => _box.read(_tokenKey);
  static bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  // Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _box.write(_refreshTokenKey, refreshToken);
  }

  static String? get refreshToken => _box.read(_refreshTokenKey);

  // Mascot data
  static const _avatarSpeciesKey = 'avatar_species';
  static const _avatarImageKey = 'avatar_image';

  static Future<void> saveMascotIndex(int index) async {
    await _box.write(_mascotIndexKey, index);
  }

  static int get mascotIndex => _box.read(_mascotIndexKey) ?? 0;

  static Future<void> saveAvatarSpecies(String species) async {
    await _box.write(_avatarSpeciesKey, species);
  }

  static String get avatarSpecies => _box.read(_avatarSpeciesKey) ?? 'lion';

  static Future<void> saveAvatarImage(String? imageUrl) async {
    if (imageUrl != null) {
      await _box.write(_avatarImageKey, imageUrl);
    } else {
      await _box.remove(_avatarImageKey);
    }
  }

  static String? get avatarImage => _box.read(_avatarImageKey);


  // ── Completed exercises ────────────────────────────────────────────────
  static const _doneExercisesKey = 'done_exercise_ids';

  /// Returns the set of exercise IDs the user has already completed.
  static Set<int> get doneExerciseIds {
    final raw = _box.read<List>(_doneExercisesKey);
    if (raw == null) return {};
    return raw.map((e) => e as int).toSet();
  }

  /// Marks a single exercise as done (idempotent).
  static Future<void> markExerciseDone(int exerciseId) async {
    final ids = doneExerciseIds..add(exerciseId);
    await _box.write(_doneExercisesKey, ids.toList());
  }

  /// Clears all saved exercise completions (e.g. when a new plan is fetched).
  static Future<void> clearDoneExercises() async {
    await _box.remove(_doneExercisesKey);
  }

  // ── Clear methods ───────────────────────────────────────────────────────
  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshTokenKey);
  }

  static Future<void> logout() async {
    await _box.erase(); // Clear everything
  }
}