import 'dart:convert';

import 'package:ai_fitness_app/core/constants/app_constant.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/otp_verification_screen.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    const endpoint = AppConstant.forgotPasswordEndpoint;
    final body = {'email': emailController.text.trim()};

    try {
      AppLog.request(endpoint, body: body);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${StorageService.accessToken}',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);

        CustomSnackBar.success(data['message'] ?? 'Reset code sent to your email.');
        AppNavigation.push(OtpVerificationScreen(
          email: emailController.text.trim(),
          isFromSignUp: false,
        ));
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);

        final message = data['detail'] ?? data['message'] ?? 'Something went wrong';
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
    emailController.dispose();
    emailFocus.dispose();
    super.onClose();
  }
}