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

  // Mascot (workout_buddy) index
  static Future<void> saveMascotIndex(int index) async {
    await _box.write(_mascotIndexKey, index);
  }

  static int get mascotIndex => _box.read(_mascotIndexKey) ?? 0;


  // Clear methods
  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshTokenKey);
  }

  static Future<void> logout() async {
    await _box.erase(); // Clear everything
  }
}