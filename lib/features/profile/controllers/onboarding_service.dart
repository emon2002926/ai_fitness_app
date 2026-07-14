import 'dart:convert';
import 'package:ai_fitness_app/features/profile/controllers/profile_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../auth/views/sign_in_screen.dart';

class OnboardingService {
  static const _endpoint = AppConstant.onboardingEndpointGet;

  final conroller  = Get.find<ProfileController>();
  static Future<bool> patch(Map<String, dynamic> fields) async {
    try {
      AppLog.request(_endpoint, method: 'PATCH');

      final response = await http.patch(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer ${StorageService.accessToken}',
          'accept':        'application/json',
          'Content-Type':  'application/json',
        },
        body: jsonEncode(fields),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(_endpoint, data);
        Get.find<ProfileController>().fetchAll();
        return true;
      } else if (response.statusCode == 401) {
        AppLog.error(_endpoint, data, statusCode: response.statusCode);
        await StorageService.logout();
        AppNavigation.pushAndClear(const SignInScreen());
        return false;
      } else {
        AppLog.error(_endpoint, data, statusCode: response.statusCode);
        return false;
      }
    } catch (e) {
      AppLog.error(_endpoint, e.toString());
      return false;
    }
  }
}