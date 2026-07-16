import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constant.dart';
import '../../../core/util/app_log.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/account_created_screen.dart';
import '../views/reset_password_screen.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {

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

  Future<void> verifyCode(String email, bool isFromSignUp) async {
    if (otp.length < 6) {
      CustomSnackBar.error('Please enter the complete 6-digit code.');
      return;
    }

    isLoading.value = true;

    final endpoint = isFromSignUp
        ? AppConstant.activateAccountEndpoint
        : AppConstant.forgotPasswordVerifyEndpoint;

    final body = {'email': email, 'code': otp};

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

        if (isFromSignUp) {
          await StorageService.saveToken(data['access']);
          await StorageService.saveRefreshToken(data['refresh']);
          await Future.delayed(const Duration(milliseconds: 100));
          AppLog.info('Token saved: ${StorageService.accessToken}');

          print('KDXFJhdgh: ${data['access']}');
          AppNavigation.push(AccountCreatedScreen());
        } else {
          AppNavigation.push(ResetPasswordScreen(email: email, otp: otp));
        }
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        final message = data['detail'] ?? data['message'] ?? 'Verification failed';
        CustomSnackBar.error(message);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp( String email) async {
    const endpoint = AppConstant.resendOtpEndpoint;
    final body = {'email': email};

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
        CustomSnackBar.success(data['message'] ?? 'Code resent to $email');
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);
        final message = data['email']?['message'] ?? data['detail'] ?? 'Failed to resend code';
        CustomSnackBar.error(message);
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');
    }
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