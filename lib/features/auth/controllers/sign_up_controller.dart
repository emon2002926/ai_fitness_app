import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api/services/api_services.dart';
import '../../../core/util/app_navigation.dart';
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
    AppNavigation.push(OtpVerificationScreen(email: "",isFromSignUp: true,));

        // if (!formKey.currentState!.validate()) return;
    //
    // isLoading.value = true;
    // try {
    //   final raw = await _api.post(
    //     '/auth/user/signup',
    //     body: {
    //       'name': fullNameController.text.trim(),
    //       'email': emailController.text.trim(),
    //       'mobile': mobileController.text.trim(),
    //       'password': passwordController.text.trim(),
    //     },
    //   );
    //
    //   final response = SignUpResponseModel.fromJson(raw);
    //
    //   if (response.data == null) {
    //     CustomSnackBar.error('Registration failed. Please try again.');
    //     return;
    //   }
    //
    //   CustomSnackBar.success('Account created! Please verify your email.');
    //   await Future.delayed(const Duration(milliseconds: 500));
    //   AppNavigation.push(OtpVerificationScreen(
    //     email: emailController.text.trim(),
    //     isFromSignUp: true,
    //   ));
    // } on HttpException catch (e) {
    //   CustomSnackBar.error(e.message);
    // } finally {
    //   isLoading.value = false;
    // }
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