import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your new password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> updatePassword(String email) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final endpoint = AppConstant.setNewPasswordEndpoint;
    final body = {
      'email': email,
      'password': passwordController.text,
      'confirm_password': confirmPasswordController.text,
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

        CustomSnackBar.success(data['message'] ?? 'Password updated successfully!');
        await Future.delayed(const Duration(milliseconds: 800));
        // AppNavigation.pushAndClear(SignInScreen());
        Get.offAll(SignInScreen());
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);

        final message = data['detail'] ?? data['message'] ?? 'Failed to reset password';
        CustomSnackBar.error(message);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.onClose();
  }
}