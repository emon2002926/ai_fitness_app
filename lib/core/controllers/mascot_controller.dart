import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/app_assert_image.dart';
import '../constants/app_constant.dart';
import '../util/app_log.dart';
import '../util/storage_service.dart';

/// Holds the user's selected mascot (`workout_buddy`) so any screen can show
/// the matching image reactively. The index is fetched from the onboarding
/// endpoint and cached in storage so it stays available across screens.
class MascotController extends GetxController {
  final index = StorageService.mascotIndex.obs;

  String get image => AppAssertImage.instance.mascotByIndex(index.value);

  /// Returns the already-registered controller, or creates a permanent one.
  static MascotController get to => Get.isRegistered<MascotController>()
      ? Get.find<MascotController>()
      : Get.put(MascotController(), permanent: true);

  Future<void> fetchMascot() async {
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
        final buddy = data['data']?['workout_buddy'];
        if (buddy is int) {
          index.value = buddy;
          await StorageService.saveMascotIndex(buddy);
        }
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    }
  }
}
