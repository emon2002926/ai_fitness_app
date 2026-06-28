import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';

class PlanReadyController extends GetxController {
  final isLoading = true.obs;
  final statusMessage = 'Generating your plan...'.obs;
  final calories = 0.obs;
  final protein = 0.obs;

  WebSocket? _socket;

  static const String _generateEndpoint = '${AppConstant.baseUrl}/api/v1/service/onboarding/generate-plan/';
  static const String _workoutListEndpoint = '${AppConstant.baseUrl}/api/v1/service/onboarding/workout-plan/list/';

  @override
  void onInit() {
    super.onInit();
    _startFlow();
    print("ashgfgja:${StorageService.accessToken}");
  }

  Future<void> _startFlow() async {
    final userId = await _generatePlan();
    if (userId != null) {
      _connectWebSocket(userId);
    }
  }

  Future<int?> _generatePlan() async {
    try {
      AppLog.request(_generateEndpoint, method: 'POST');

      final response = await http.post(
        Uri.parse(_generateEndpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLog.response(_generateEndpoint, data);
        return data['data']['user_id'] as int?;
      } else {
        AppLog.error(_generateEndpoint, data, statusCode: response.statusCode);
        final message = data['detail'] ?? data['message'] ?? 'Failed to generate plan';
        CustomSnackBar.error(message);
        return null;
      }
    } catch (e) {
      AppLog.error(_generateEndpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');
      return null;
    }
  }

  void _connectWebSocket(int userId) {
    final wsUrl = 'wss://lexiapi.dsrt321.online/ws/workout/plan/$userId/';
    AppLog.info('WS connecting → $wsUrl');

    WebSocket.connect(
      wsUrl,
      headers: {'Authorization': 'Bearer ${StorageService.accessToken}'},
    ).then((socket) {
      _socket = socket;
      AppLog.info('WS connected');

      socket.listen(
            (event) {
          final data = jsonDecode(event as String);
          AppLog.info('WS message: $event');

          final status = data['status'] as String?;
          final message = data['message'] as String?;

          if (message != null) statusMessage.value = message;

          if (status == 'completed') {
            _socket?.close();
            _fetchWorkoutPlan();
          } else if (status == 'error') {
            _socket?.close();
            isLoading.value = false;
            CustomSnackBar.error(message ?? 'Plan generation failed.');
          }
        },
        onError: (e) {
          AppLog.error('WebSocket', e.toString());
          isLoading.value = false;
          CustomSnackBar.error('Connection error. Please try again.');
        },
        onDone: () {
          AppLog.info('WS connection closed');
        },
      );
    }).catchError((e) {
      AppLog.error('WebSocket connect', e.toString());
      isLoading.value = false;
      CustomSnackBar.error('Failed to connect. Please try again.');
    });
  }

  Future<void> _fetchWorkoutPlan() async {
    try {
      AppLog.request(_workoutListEndpoint, method: 'GET');

      final response = await http.get(
        Uri.parse(_workoutListEndpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(_workoutListEndpoint, data);

        final plans = data['data'] as List?;
        if (plans != null && plans.isNotEmpty) {
          final nutrition = plans[0]['nutrition'];
          calories.value = int.tryParse(nutrition['daily_calories'].toString()) ?? 0;
          protein.value = int.tryParse(nutrition['daily_protein_grams'].toString()) ?? 0;
        }

        isLoading.value = false;
      } else {
        AppLog.error(_workoutListEndpoint, data, statusCode: response.statusCode);
        isLoading.value = false;
        CustomSnackBar.error('Failed to load plan details.');
      }
    } catch (e) {
      AppLog.error(_workoutListEndpoint, e.toString());
      isLoading.value = false;
      CustomSnackBar.error('Something went wrong. Please try again.');
    }
  }

  @override
  void onClose() {
    _socket?.close();
    super.onClose();
  }
}