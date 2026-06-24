import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/services/api/services/api_services.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/otp_verification_screen.dart';
import '../views/sign_in_screen.dart';



class SignUpController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ApiServices _api = Get.find<ApiServices>();

  final fullNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final mobileFocus = FocusNode();
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

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your full name';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your mobile number';
    if (value.trim().length < 7) return 'Please enter a valid mobile number';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    const endpoint = AppConstant.signUpEndpoint;
    final body = {
      'email': emailController.text.trim(),
      'full_name': fullNameController.text.trim(),
      'phone_number': mobileController.text.trim(),
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

      if (response.statusCode == 201) {
        AppLog.response(endpoint, data);

        CustomSnackBar.success(data['message'] ?? 'Account created! Please verify your email.');
        AppNavigation.push(OtpVerificationScreen(
          email: emailController.text.trim(),
          isFromSignUp: true,
        ));
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);

        final message = data['detail'] ?? data['message'] ?? 'Registration failed';
        CustomSnackBar.error(message);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
  void navigateToSignIn() => AppNavigation.push(SignInScreen());

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameFocus.dispose();
    emailFocus.dispose();
    mobileFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.onClose();
  }
}