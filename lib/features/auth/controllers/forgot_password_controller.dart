import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/util/app_navigation.dart';
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
    // if (!formKey.currentState!.validate()) return;
    //
    // isLoading.value = true;
    // try {
    //   // TODO: call API
    //   await Future.delayed(const Duration(seconds: 1));
    //
      CustomSnackBar.success('Reset code sent to your email.');
      AppNavigation.push(OtpVerificationScreen(
        email: emailController.text.trim(),
        isFromSignUp: false,
      ));
    // } finally {
    //   isLoading.value = false;
    // }
  }

  @override
  void onClose() {
    emailController.dispose();
    emailFocus.dispose();
    super.onClose();
  }
}