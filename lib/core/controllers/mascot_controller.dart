import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../features/home/controllers/home_controller.dart';
import '../../features/work_out/controllers/workout_controller.dart';
import '../../features/nutrition/controllers/nutrition_controller.dart';

import '../constants/app_assert_image.dart';
import '../constants/app_constant.dart';
import '../util/app_log.dart';
import '../util/storage_service.dart';

/// Holds the user's selected mascot and avatar image so any screen can show
/// the matching image reactively.
class MascotController extends GetxController {
  final index = StorageService.mascotIndex.obs; // Legacy index if still needed
  final species = StorageService.avatarSpecies.obs;
  final avatarImageUrl = RxnString(StorageService.avatarImage);

  /// Returns the already-registered controller, or creates a permanent one.
  static MascotController get to => Get.isRegistered<MascotController>()
      ? Get.find<MascotController>()
      : Get.put(MascotController(), permanent: true);

  Future<void> fetchMascot() async {
    const endpoint = '${AppConstant.baseUrl}/api/v1/service/avatar/';
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
        final payload = data['data'];
        
        if (payload != null) {
          if (payload['species'] != null) {
             species.value = payload['species'];
             await StorageService.saveAvatarSpecies(payload['species']);
          }
          if (payload['avatar_image'] != null) {
             avatarImageUrl.value = payload['avatar_image'];
             await StorageService.saveAvatarImage(payload['avatar_image']);
          } else {
             avatarImageUrl.value = null;
             await StorageService.saveAvatarImage(null);
          }
        }
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
    }
  }
  
  WebSocket? _socket;
  
  final isPlanGenerating = false.obs;

  void connectWebSocket(int userId) {
    if (_socket != null) return;
    
    final wsUrl = 'wss://lexiapi.dsrt321.online/ws/workout/plan/$userId/';
    AppLog.info('Global WS connecting → $wsUrl');

    WebSocket.connect(
      wsUrl,
      headers: {'Authorization': 'Bearer ${StorageService.accessToken}'},
    ).then((socket) {
      _socket = socket;
      AppLog.info('Global WS connected');

      socket.listen(
        (event) async {
          final data = jsonDecode(event as String);
          AppLog.info('Global WS message: $event');

          final status = data['status'] as String?;
          final message = data['message'] as String?;

          if (message == 'Avatar image updated' && data['data'] != null) {
             final newImage = data['data']['avatar_image'];
             avatarImageUrl.value = newImage;
             await StorageService.saveAvatarImage(newImage);
          }
          
          if (status == 'in_progress') {
             isPlanGenerating.value = true;
          } else if (status == 'completed') {
             isPlanGenerating.value = false;
             if (Get.isRegistered<HomeController>()) {
               Get.find<HomeController>().fetchTodayWorkoutPlan();
             }
             if (Get.isRegistered<WorkoutController>()) {
               Get.find<WorkoutController>().fetchWorkoutPlan();
             }
             if (Get.isRegistered<NutritionController>()) {
               Get.find<NutritionController>().fetchMealPlan();
             }
          } else if (status == 'error') {
             isPlanGenerating.value = false;
          }
        },
        onError: (e) {
          AppLog.error('Global WebSocket error', e.toString());
          _socket = null;
        },
        onDone: () {
          AppLog.info('Avatar WS connection closed');
          _socket = null;
        },
      );
    }).catchError((e) {
      AppLog.error('Avatar WebSocket connect failed', e.toString());
    });
  }
  
  @override
  void onClose() {
    _socket?.close();
    super.onClose();
  }
}
