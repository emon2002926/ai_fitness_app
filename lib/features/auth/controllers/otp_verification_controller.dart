import 'package:flutter/cupertino.dart';

import '../../../core/util/app_navigation.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/account_created_screen.dart';
import '../views/reset_password_screen.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  final String email;
  final bool isFromSignUp;

  OtpVerificationController({required this.email, required this.isFromSignUp});

  final List<TextEditingController> otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;

  String get otp => otpControllers.map((c) => c.text).join();

  void onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyCode() async {
    // if (otp.length < 6) {
    //   CustomSnackBar.error('Please enter the complete 6-digit code.');
    //   return;
    // }
    //
    // isLoading.value = true;
    // try {
    //   // TODO: call API
    //   await Future.delayed(const Duration(seconds: 1));

    if (isFromSignUp) {
      AppNavigation.push(AccountCreatedScreen());
    } else {
      AppNavigation.push(ResetPasswordScreen(email: email, otp: otp));
    }
    //   } finally {
    //     isLoading.value = false;
    //   }
  }
  Future<void> resendOtp() async {
    // TODO: call API
    CustomSnackBar.success('Code resent to $email');
  }

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}