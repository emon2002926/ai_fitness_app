
import 'dart:convert';

import 'package:ai_fitness_app/features/base_screen/views/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../views/sign_up_screen.dart';
class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    const endpoint = 'https://lexiapi.dsrt321.online/api/v1/auth/login/';
    final body = {
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };

    try {
      AppLog.request(endpoint, body: body);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        await StorageService.saveToken(data['access']);
        await StorageService.saveRefreshToken(data['refresh']);

        AppNavigation.pushAndClear(BasePage());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);

        final message = data['detail'] ?? data['message'] ?? 'Login failed';
        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());

      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  void navigateToSignUp() => AppNavigation.push(SignUpScreen());
  // void navigateToForgetPassword() => AppNavigation.push(ForgetPasswordScreen());

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}