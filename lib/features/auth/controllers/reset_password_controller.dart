import '../../../core/util/app_navigation.dart';
import '../views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ResetPasswordController extends GetxController {
  final String email;
  final String otp;

  ResetPasswordController({required this.email, required this.otp});

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

  Future<void> updatePassword() async {
    // if (!formKey.currentState!.validate()) return;
    //
    // isLoading.value = true;
    // try {
    //   // TODO: call API
    //   await Future.delayed(const Duration(seconds: 1));
    //
    //   CustomSnackBar.success('Password updated successfully!');
      AppNavigation.push(SignInScreen());
    // } finally {
    //   isLoading.value = false;
    // }
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